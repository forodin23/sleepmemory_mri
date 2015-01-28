function mt_dialogues(rootdir)
% ** function mt_dialogues(rootdir)
% This script creates dialogue windows to configure the experiment. The
% questions and defaults can be found and adjustet in "prompts.txt" and
% "defaults.txt", respectively. Note that each line corresponds to one
% dialogue.
%
% IMPORTANT: For this script to work you have to copy the function "newid.m"
% to folder displayed if you execute "which -all inputdlg" 
% Source: http://www.mathworks.com/matlabcentral/answers/uploaded_files/1727/newid.m
% 
% USAGE:
%     mt_dialogues;
%
% >>> INPUT VARIABLES >>>
% NAME              TYPE        DESCRIPTION
% rootdir           char        path to root working directory
%
%
% AUTHOR: Marco R�th, contact@marcorueth.com

%% Load parameters specified in mt_setup.m
load(fullfile(rootdir,'setup','mt_params.mat'))   % load workspace information and properties

%% Read in questions/default answers shown in the dialogue windows
% Read in dialogue questions
fid                 = fopen(fullfile(rootdir,'code','prompts.txt'));
prompts             = textscan(fid,'%s','Delimiter','\n');
prompts             = prompts{1};
fclose(fid);
% Read in dialogue default answers
fid                 = fopen(fullfile(rootdir,'code','defaults.txt'));
defaults            = textscan(fid,'%s','Delimiter','\n');
defaults            = defaults{1};
fclose(fid);
% Pre-allocation of cell array for answer strings
answers             = cell(length(prompts),1);

%% Show dialogue windows and save the answers
dlgBackground = figure('name', 'dlgBackground', 'units', 'normalized', 'outerposition', [0 0 1 1] , 'Color', [1 1 1], ...
    'NumberTitle','off', 'menubar', 'none', 'toolbar', 'none', 'Color', 'white');
options.WindowStyle='modal';
for p = 1 : length(prompts)
    answers{p,:} 	= newid(prompts(p), '', [1 70], defaults(p), options);
    if strcmp(char(answers{1,:}), 'debug')     
        load(fullfile(setupdir, 'mt_debug.mat'))
        break;
    end
end
close('dlgBackground')

% Store answers in struct fields
% Questions can be found in prompts.txt, defaults in defaults.txt
if ~exist('cfg_dlgs', 'var')
    cfg_dlgs.subject 	= char(answers{1, 1}); % Subject ID
    cfg_dlgs.night      = char(answers{2, 1}); % Night number
    cfg_dlgs.memvers    = char(answers{3, 1}); % Memory version
    cfg_dlgs.sesstype 	= char(answers{4, 1}); % Session type
    cfg_dlgs.lab        = char(answers{5, 1}); % Lab
end

% save(fullfile(setupdir, 'mt_debug.mat'), 'cfg_dlgs') % decomment for new debug mat-file

%% Evaluate the answers to set memory version, session type, and lab
% Create a new folder for the subject data
subdir = fullfile('DATA',strcat('Subject_', cfg_dlgs.subject),strcat('Night_', cfg_dlgs.night));
mkdir(fullfile(rootdir,'DATA',strcat('Subject_', cfg_dlgs.subject)), ...
        strcat('Night_', cfg_dlgs.night))


% Memory version
switch cfg_dlgs.memvers
    case 'A' 
        cfg_dlgs.memvers = 1; % Version A of memory
    case 'B'
        cfg_dlgs.memvers = 2; % Version B of memory
    otherwise
        error('Invalid Memory Version')
end

% Session type: defines cardSequence
switch cfg_dlgs.sesstype
    case 'C'
        cfg_dlgs.sesstype = 4;
    case 'G' % gray background and no images are shown
        screenBgColor   = 0.5;
        topCardColor    = 0.5;
        frameWidth      = 0;
        save(fullfile(rootdir,'setup','mt_params.mat'), '-append', ...
            'screenBgColor', 'topCardColor', 'frameWidth')
        cfg_dlgs.sesstype = 2; 
    case 'L' 
        cfg_dlgs.sesstype = 1; % Learning
    case 'R'
        cfg_dlgs.sesstype = 2; % Recall
    case 'I'
        cfg_dlgs.sesstype = 3; % Interference
    otherwise
        error('Invalid Session Type')
end

% Lab
switch cfg_dlgs.lab
    case 'M' 
        cfg_dlgs.lab = 1;
        % TODO: set triggers for MEG
        % Parallel port trigger in PTB
        % In the MEG will be the old olfactometer
    case 'SL 3'
        cfg_dlgs.lab = 2;
        % TODO: set triggers for sleep lab (left)
        % In the sleep lab will be the new olfactometer
    case 'SL 4'
        % TODO: set triggers for sleep lab (right)
        % In the sleep lab will be the new olfactometer
        % Only in this lab one can learn and stimulate with odors
    otherwise
        error('Invalid Lab')
end

%% Save configuration in rootdir
save(fullfile(setupdir,'mt_params.mat'), '-append', 'cfg_dlgs', 'subdir')

end