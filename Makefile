.DEFAULT_GOAL := help

# determines what "make help" will show
define PRINT_HELP_PYSCRIPT
import re, sys

for line in sys.stdin:
	match = re.match(r'^([a-zA-Z_-]+):.*?## (.*)$$', line)
	if match:
		target, help = match.groups()
		print("%-20s %s" % (target, help))
endef
export PRINT_HELP_PYSCRIPT

# TODO make more general to use the local matlab version
MATLAB = /usr/local/MATLAB/R2017a/bin/matlab
ARG    = -nodisplay -nosplash -nodesktop

################################################################################
#   General

.PHONY: help clean clean_demos clean_test update fix_submodule

help: ## Show what this Makefile can do
	@python -c "$$PRINT_HELP_PYSCRIPT" < $(MAKEFILE_LIST)
clean: clean_demos clean_doc clean_test ## Remove all the clutter
	rm -rf version.txt
clean_demos: ## Remove all the output of the demo
	rm -rf demos/*/cfg
	rm -rf demos/*/outputs/derivatives
	rm -rf demos/*/inputs
	rm -rf demos/*/*.zip
	rm -rf demos/*/*_report.md

clean_test:	## Remove all the output of the tests
	rm *.log
	rm -rf coverage_html
update: update.sh ## Tries to get the latest version of the current branch from upstream
	bash update.sh

fix_submodule: ## Fix any submodules that would not be checked out
	git submodule update --init --recursive && git submodule update --recursive

# TODO should update the version in
# - the doc conf.py
# - in the reference in the README
# - dockerfile
version.txt: CITATION.cff
	grep -w "^version" CITATION.cff | sed "s/version: /v/g" > version.txt

validate_cff: ## Validate the citation file
	cffconvert --validate


################################################################################
#   doc

.PHONY: clean_doc manual

clean_doc:
	cd docs && make clean

manual: ## Build PDF version of the doc
	cd docs && sh create_manual.sh


################################################################################
#   lint

.PHONY: lint lint_matlab lint_python

lint: lint_matlab lint_python ## Clean MATLAB and python code

lint_matlab: ## Clean MATLAB code
	mh_style --fix && mh_metric --ci && mh_lint

lint_python: ## Clean python code
	black *.py src docs
	flake8	*.py src docs


################################################################################
#   test

.PHONY: test system_test
test: run_tests.m initCppSpm.m src tests ## Run tests with coverage
	$(MATLAB) $(ARG) -r "run_tests; exit()"
system_test: manualTests/test_moae.m initCppSpm.m src demos/MoAE/options demos/MoAE/models ## Run system tests
	$(MATLAB) $(ARG) -r "cd manualTests; test_moae; exit()"


################################################################################
#   DOCKER

.PHONY: clean_docker

clean_docker:
	rm -f Dockerfile_matlab

build_image: Dockerfile fix_submodule ## Build stable docker image from the main branch
	git checkout main
	docker build . --no-cache -f Dockerfile -t cpplab/cpp_spm:stable
	VERSION=$(cat version.txt | cut -c2-)
	docker tag cpplab/cpp_spm:stable cpplab/cpp_spm:$$VERSION

build_image_dev: Dockerfile ## Build latest docker image from the dev branch
	git checkout dev
	VERSION=$(cat version.txt | cut -c2-)
	docker build . --no-cache -f Dockerfile -t cpplab/cpp_spm:latest
	docker tag cpplab/cpp_spm:latest cpplab/cpp_spm:$$VERSION

build_image_test: ## For debugging docker image building
	docker build . -f Dockerfile -t cpplab/cpp_spm:test

Dockerfile_matlab:
	docker run --rm repronim/neurodocker:0.7.0 generate docker \
		--pkg-manager apt \
		--base debian:stretch-slim \
		--spm12 version=r7771 \
		--install nodejs npm \
		--run "node -v && npm -v && npm install -g bids-validator" \
		--user neuro \
		--run "mkdir code output cpp_spm" \
		--copy ".", "/home/neuro/cpp_spm/" > Dockerfile_matlab

build_image_matlab_dev: Dockerfile_matlab
	VERSION=$(cat version.txt | cut -c2-)
	docker build . -f Dockerfile_matlab -t cpplab/cpp_spm:matlab_$$VERSION

################################################################################
