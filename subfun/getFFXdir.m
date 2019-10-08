function ffxDir = getFFXdir(subNumber, degreeOfSmoothing, opt)
ffxDir = fullfile(opt.derivativesDir,...
    ['sub-',subNumber],...
    ['stats'],...
    ['ffx_',opt.taskName],...
    ['ffx_',num2str(degreeOfSmoothing)']);

if ~exist(ffxDir,'dir')
    mkdir(ffxDir)
end
end