function [dirRoot, dirPTB] = mt_profile(user)
% ** function mt_profile(user)
% Loads user-specific root directory and Psychtoolbox installation folder
%
% USAGE:
%       [dirRoot, dirPTB]   = mt_profile(user);
%
% >>> INPUT VARIABLES >>>
% NAME              TYPE        DESCRIPTION
% user              char       	user name
%
% <<< OUTPUT VARIABLES <<<
% NAME              TYPE        DESCRIPTION
% dirRoot           char        path to root working directory
% dirPTB            char        path to Psychtoolbox installation folder
%
% 
% AUTHOR: Marco R�th, contact@marcorueth.com

switch upper(user)
    case 0
        dirRoot             = 'C:\Users\t3ch\Documents\GitHub\sleepmemory_mri\';
        dirPTB              = 'D:\Software\AnalysisSoftware\PTB\Psychtoolbox\';
    case {'MRI'}
       dirRoot              = 'E:\USERS\veit\memory_psychtoolbox\sleepmemory';
       dirPTB               = 'C:\Program Files\MATLAB\Psyschtoolbox\Psychtoolbox'; 
    otherwise
        error('Invalid User Name. Define workspace in mt_profile.m')
end
addpath(genpath(dirRoot))
addpath(dirPTB)
end