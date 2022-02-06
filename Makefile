# TODO make more general to use the local matlab version
MATLAB = /usr/local/MATLAB/R2017a/bin/matlab
ARG    = -nodisplay -nosplash -nodesktop

.PHONY: clean manual clean_demos fix_submodule
clean: clean_demos
	rm -rf version.txt

clean_demos:
	rm -rf demos/*/cfg
	rm -rf demos/*/outputs/derivatives
	rm -rf demos/*/inputs
	rm -rf demos/*/*.zip
	rm -rf demos/*/*_report.md

fix_submodule:
	git submodule update --init --recursive && git submodule update --recursive

lint:
	mh_style --fix && mh_metric --ci && mh_lint

system_test: manualTests/test_moae.m initCppSpm.m src demos/MoAE/options demos/MoAE/models
	$(MATLAB) $(ARG) -r "cd manualTests; test_moae; exit()"

test: run_tests.m initCppSpm.m src tests
	$(MATLAB) $(ARG) -r "run_tests; exit()"

docker_images: Dockerfile Dockerfile_dev
	bash build_image.sh


version.txt: CITATION.cff
	grep -w "^version" CITATION.cff | sed "s/version: /v/g" > version.txt

validate_cff: CITATION.cff
	cffconvert --validate

manual:
	cd docs && sh create_manual.sh
