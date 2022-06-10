%
% (C) Copyright 2021 CPP_SPM developers

root_dir = getenv('GITHUB_WORKSPACE');

addpath(fullfile(root_dir, 'spm12'));

cd(fullfile(root_dir, 'demos', 'face_repetition'));

run test_face_rep;