function mt_ITImri(user)
% ** function mt_setup(user) 
% This script generates the inter trial intervals for the memory task.
% 
%
% >>> INPUT VARIABLES >>>
% NAME              TYPE        DESCRIPTION
% user              char       	pre-defined user name (see mt_loadUser.m)
%
% 
% AUTHOR: Marco Rüth, contact@marcorueth.com

% IMPORTANT: add your user profile in mt_loadUser
[dirRoot, dirPTB]   = mt_profile(user);

% Folder for configurations
setupdir            = fullfile(dirRoot, 'setup');
if ~exist(setupdir, 'dir')
    mkdir(setupdir) % create folder in first run
end

% Create ITIs
ITImri = randsample(0.5:0.01:1.5, 20, 1);

% Save values of inter trial interval (ITI) for MRI
save(fullfile(setupdir, 'mt_ITImri.mat'), 'ITImri');