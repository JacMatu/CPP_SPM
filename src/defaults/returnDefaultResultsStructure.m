function results  = returnDefaultResultsStructure()
  %
  % (C) Copyright 2019 CPP_SPM developers

  Output = struct('png', false(), ...
                  'csv', false(), ...
                  'thresh_spm', false(), ...
                  'binary', false(), ...
                  'montage', struct('do', false(), ...
                                    'slices', [], ...
                                    'orientation', 'axial', ...
                                    'background',  fullfile(spm('dir'), ...
                                                            'canonical', ...
                                                            'avg152T1.nii')), ...
                  'NIDM_results', false());

  results = struct('Level',  '', ...
                   'Name',  '', ...
                   'Contrasts', returnDefaultContrastsStructure(), ...
                   'Output', Output);

end
