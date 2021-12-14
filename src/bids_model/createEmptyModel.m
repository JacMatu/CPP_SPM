function model = createEmptyModel()
  %
  % (C) Copyright 2020 CPP_SPM developers

  model = struct( ...
                 'X', {{' '}}, ...
                 'Options', struct('HighPassFilterCutoffHz', 0.0078), ...
                 'Software', struct('SPM', struct('whitening', 'FAST')), ...
                 'Mask', {' '});
end
