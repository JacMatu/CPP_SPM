% (C) Copyright 2021 CPP_SPM developers

function test_suite = test_spm2bidsCPP %#ok<*STOUT>
  try % assignment of 'localfunctions' is necessary in Matlab >= 2016
    test_functions = localfunctions(); %#ok<*NASGU>
  catch % no problem; early Matlab versions can use initTestSuite fine
  end
  initTestSuite;
end

function test_spm2bidsCPP_lesion_segmenting()

  anatFile = 'sub-01_T1w.nii';

  opt = setOptions('vismotion');

  opt = setRenamingConfig(opt, 'LesionSegmentation');

  opt.verbosity = 2;

  pfx_in_out = {
                {'rc1'}, ...
                anatFile, ...
                'sub-01_space-individual_res-r2pt0_label-GM_probseg.nii'; ...
                {'rc2'}, ...
                anatFile, ...
                'sub-01_space-individual_res-r2pt0_label-WM_probseg.nii'; ...
                {'rc3'}, ...
                anatFile, ...
                'sub-01_space-individual_res-r2pt0_label-CSF_probseg.nii'; ...
                {'rc4'}, ...
                anatFile, ...
                'sub-01_space-individual_res-r2pt0_label-PRIOR_probseg.nii'; ...
                {'wc4'}, ...
                anatFile, ...
                'sub-01_space-IXI549Space_res-r2pt0_label-PRIOR_probseg.nii'; ...
                {'wc4prior1'}, ...
                anatFile, ...
                'sub-01_space-IXI549Space_res-r1pt5_label-PRIOR_desc-nextIte_probseg.nii'; ...
                {'wc4previous1'}, ...
                anatFile, ...
                'sub-01_space-IXI549Space_res-r1pt5_label-PRIOR_desc-prevIte_probseg.nii'; ...
                {'swc1'}, ...
                anatFile, ...
                'sub-01_space-IXI549Space_res-r2pt0_label-GM_desc-smth8_probseg.nii'; ...
                {'swc2'}, ...
                anatFile, ...
                'sub-01_space-IXI549Space_res-r2pt0_label-WM_desc-smth8_probseg.nii' ...
               };

  for i = 1:size(pfx_in_out, 1)

    prefixes = getPrefixes(pfx_in_out, i);

    for j = 1:numel(prefixes)

      file = [prefixes{j} pfx_in_out{i, 2}];

      filename = spm_2_bids(file, opt.spm_2_bids);

      msg = sprintf('%s --> %s\n', file, filename);
      printToScreen(msg, opt);

      expected = pfx_in_out{i, 3};
      assertEqual(filename, expected);

    end
  end

end

function test_spm2bidsCPP_mapping_func()

  opt = setOptions('vismotion');

  opt = set_spm_2_bids_defaults(opt);

  funcFile = 'sub-01_task-auditory_bold.nii';

  funcFileRun1 = 'sub-01_task-auditory_run-1_bold.nii';

  pfx_in_out = {{'mean_'}, ...
                funcFileRun1, ...
                'sub-01_task-auditory_run-1_space-individual_desc-mean_bold.nii'; ...
                {'std_'}, ...
                funcFileRun1, ...
                'sub-01_task-auditory_run-1_space-individual_desc-std_bold.nii'; ...
                {'mean_'}, ...
                funcFile, ...
                'sub-01_task-auditory_space-individual_desc-mean_bold.nii'; ...
                {'std_'}, ...
                funcFile, ...
                'sub-01_task-auditory_space-individual_desc-std_bold.nii'; ...
                {'s6u', 's6r', 's6ua', 's6ra'},  ...
                funcFile, ...
                'sub-01_task-auditory_space-individual_desc-smth6_bold.nii'; ...
                {'s6wu', 's6wr', 's6wua', 's6wra'},  ...
                funcFile, ...
                'sub-01_task-auditory_space-IXI549Space_desc-smth6_bold.nii'; ...
                {'s6'}, ...
                funcFile, ...
                'sub-01_task-auditory_desc-smth6_bold.nii'; ...
                {'rp_'}, ...
                funcFile, ...
                'sub-01_task-auditory_motion.tsv'; ...
                {'rp_a'}, ...
                funcFile, ...
                'sub-01_task-auditory_motion.tsv'; ...
                {'u', 'ua'}, ...
                funcFile, ...
                'sub-01_task-auditory_space-individual_desc-preproc_bold.nii'; ...
                {'m'}, ...
                'sub-01_space-individual_desc-something_label-brain_mask.nii', ...
                'sub-01_space-individual_label-brain_mask.nii'; ...
                {'std_u', 'std_ua'}, ...
                funcFile, ...
                'sub-01_task-auditory_space-individual_desc-std_bold.nii' ...
               };

  for i = 1:size(pfx_in_out, 1)

    prefixes = getPrefixes(pfx_in_out, i);

    for j = 1:numel(prefixes)

      file = [prefixes{j} pfx_in_out{i, 2}];

      filename = spm_2_bids(file, opt.spm_2_bids);

      msg = sprintf('%s --> %s\n', file, filename);
      printToScreen(msg, opt);

      expected = pfx_in_out{i, 3};
      assertEqual(filename, expected);

    end
  end

end

function test_spm2bidsCPP_mapping_anat()

  opt = setOptions('vismotion');

  opt = set_spm_2_bids_defaults(opt);

  anatFile = 'sub-01_T1w.nii';

  pfx_in_out = {
                {'wc1'}, ...
                anatFile, ...
                'sub-01_space-IXI549Space_res-bold_label-GM_probseg.nii'; ...
                {'wc2'}, ...
                anatFile, ...
                'sub-01_space-IXI549Space_res-bold_label-WM_probseg.nii'; ...
                {'wc3'}, ...
                anatFile, ...
                'sub-01_space-IXI549Space_res-bold_label-CSF_probseg.nii'; ...
                {'rc1'}, ...
                anatFile, ...
                'sub-01_space-individual_res-bold_label-GM_probseg.nii'; ...
                {'rc2'}, ...
                anatFile, ...
                'sub-01_space-individual_res-bold_label-WM_probseg.nii'; ...
                {'rc3'}, ...
                anatFile, ...
                'sub-01_space-individual_res-bold_label-CSF_probseg.nii'; ...
                {'wm'}, ...
                anatFile, ...
                'sub-01_space-IXI549Space_res-r1pt0_T1w.nii'; ...
                {'wm'}, ...
                'sub-01_desc-skullstripped_T1w.nii', ...
                'sub-01_space-IXI549Space_res-r1pt0_desc-preproc_T1w.nii'; ...
                {'m'}, ... % cover case w/out prefix
                'sub-01_desc-skullstripped_T1w.nii', ... % TODO cover case w/ space specified
                'sub-01_space-individual_desc-preproc_T1w.nii'; ...
                {'m'}, ...
                'sub-01_space-individual_desc-something_label-brain_mask.nii', ...
                'sub-01_space-individual_label-brain_mask.nii'; ...
                {'c1'}, ...
                'sub-01_T1w.surf.gii', ...
                'sub-01_desc-pialsurf_T1w.gii'; ...
                {'w'}, ...
                'sub-01_desc-skullstripped_T1w.nii', ...
                'sub-01_space-IXI549Space_res-r1pt0_desc-preproc_T1w.nii'; ...
                {'w'}, ...
                'sub-01_space-individual_desc-brain_mask.nii', ...
                'sub-01_space-IXI549Space_res-r1pt0_desc-brain_mask.nii' ...
               };

  for i = 1:size(pfx_in_out, 1)

    prefixes = getPrefixes(pfx_in_out, i);

    for j = 1:numel(prefixes)

      file = [prefixes{j} pfx_in_out{i, 2}];

      filename = spm_2_bids(file, opt.spm_2_bids);

      msg = sprintf('%s --> %s\n', file, filename);
      printToScreen(msg, opt);

      expected = pfx_in_out{i, 3};
      assertEqual(filename, expected);

    end
  end

end

function prefixes = getPrefixes(prefixAndOutput, row)
  prefixes = prefixAndOutput{row, 1};
  if ~iscell(prefixes)
    prefixes = {prefixes};
  end
end
