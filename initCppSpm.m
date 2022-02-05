function initCppSpm(dev)
  %
  % Adds the relevant folders to the path for a given session.
  % Has to be run to be able to use CPP_SPM.
  %
  % USAGE::
  %
  %   initCppSpm()
  %
  % (C) Copyright 2021 CPP_SPM developers

  warning('DEPRECATED: use `cpp_spm(''init'')` instead');

  if dev
    cpp_spm('dec');
  else
    cpp_spm('init');
  end

end
