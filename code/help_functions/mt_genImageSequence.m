function mt_genImageSequence(dirRoot)
% ** function mt_genImageSequence(dirRoot)
% This function writes text to the window opened by Psychtoolbox via
% mt_window
%
% USAGE:
%       mt_genImageSequence(dirRoot)
%
% >>> INPUT VARIABLES >>>
% NAME              TYPE        DESCRIPTION
% dirRoot           char        path to root working directory
%
% AUTHOR: Marco Rüth, contact@marcorueth.com

%% Load parameters specified in mt_setup.m
load(fullfile(dirRoot,'setup','mt_params.mat'), 'imageConfiguration')

nRuns = 7;
nImages = size(imageConfiguration{1}{1}, 1) * size(imageConfiguration{1}{1}, 2);

imageSequenceLists = zeros(nRuns, nImages);
for i = 1 : nRuns
   imageSequenceLists(i, :) = Shuffle(1:nImages);
end

save(fullfile(dirRoot,'setup','imageSequenceLists.mat'), 'imageSequenceLists')


end