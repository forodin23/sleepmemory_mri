function mt_run(user)
% ** function mt_run(user)
% Runs the Memory Task (mt).
% The memory task consists of 30 cards which are displayed in 5 rows of 6
% cards each. The target card to search for is displayed at the top center 
% of the screen. There are two configurations of the cards - main and 
% interference. The upper case letters correspond to the parameters in 
% the dialogues at the start. The experiment consists of three phases:
%
% 1. Main Learning & Immediate Recall (L)
%    First, one has to learn the positions of the cards during the 
%    learning phase. All cards are displayed one after another.
%    Subsequently during the immediate recall phase one has to find 
%    the picture corresponding to the one displayed at the top center. 
%
% 2. Interference Learning & Interference Recall (I)
%    Prior to recall another configuration of cards will be learned.
%    This phase consists of interference learning and interference
%    recall.
%
% 3. Main Recall (R)
%    Finally, the recall phase shows the same configuration as in ML.
%    Again, one has to find the picture corresponding to the one 
%    displayed at the top center.
%
%
% IMPORTANT: 
%  First you need to adjust the variables in "mt_setup.m"
%
% USAGE:
%       mt_run('user'); % works if user is specified in mt_profile
%
% Notes: 
%   fast/debug mode: enter 0 (zero) when prompted for subject number
%
% >>> INPUT VARIABLES >>>
% NAME              TYPE        DESCRIPTION
% user              char       	pre-defined user name (see mt_profile.m)
%
% 
% AUTHOR: Marco Rüth, contact@marcorueth.com

%% PREPARE WORKSPACE & REQUEST USER INPUT
close all;                  % Close all figures
clearvars -except user;     % Clear all variables in the workspace
iRecall         = 1;        % counter for recall sessions
perc_correct    = 0;        % initial value for percent correct clicked cards

% Initialize workspace; includes user dialogues
dirRoot         = mt_prepare(user); 

% Load workspace information and properties
try
    load(fullfile(dirRoot, 'setup', 'mt_params.mat'))
    window      = cfg_window.window(1);
catch ME
    fprintf(['mt_params.mat could not be loaded.\n', ...
        'Check the save destination folder in mt_setup.m and parameter settings.\n'])
    error(ME.message)
end

% Prepare Card Matrix
mt_setupCards(dirRoot, cfg_window);

%% START GAME   
switch upper(cfg_cases.sesstype{cfg_dlgs.sesstype})
    
% MAIN LEARNING and IMMEDIATE RECALL
case cfg_cases.sesstype{2}
%     % Show introduction screen
%     mt_showText(dirRoot, textLearningIntro{1}, window);
%     mt_showText(dirRoot, textLearningIntro{2}, window);
    % Start practice session
    mt_cardGamePractice(dirRoot, cfg_window);
    mt_showText(dirRoot, textLearning2, window);
    mt_showText(dirRoot, textQuestion, window);
    % Start learning sessions
    for block = 1: nLearningBlocks
        mt_cardGame(dirRoot, cfg_window, block, 0, 2);
        mt_showText(dirRoot, textRecallImmediate, window);
        perc_correct = mt_cardGame(dirRoot, cfg_window, block, 0, 5);
        mt_showText(dirRoot, strrep(textRecallPerformance, 'XXX', sprintf('%3.f', (100*perc_correct))), window);
        mt_showText(dirRoot, strrep(textLearning2Next, 'XXX', sprintf('%1.f', (block+1))), window);
    end
    % Show final screen
    mt_showText(dirRoot, textOutro, window);
    sca;

% INTERFERENCE BLOCKS
case cfg_cases.sesstype{3}
    % Show introduction screen
    mt_showText(dirRoot, textLearningInterference, window);
    mt_showText(dirRoot, textQuestion, window);
    % Start interference sessions
    for block = 1: nInterferenceBlocks
        mt_cardGame(dirRoot, cfg_window, block, 0, 3);
        mt_showText(dirRoot, textRecallImmediate, window);
        perc_correct = mt_cardGame(dirRoot, cfg_window, block, 0, 5);
        mt_showText(dirRoot, strrep(textRecallPerformance, 'XXX', sprintf('%3.f', (100*perc_correct))), window);
        mt_showText(dirRoot, strrep(textLearning2Next, 'XXX', sprintf('%1.f', (block+1))), window);
    end
    mt_showText(dirRoot, textLearning2, window);
    mt_showText(dirRoot, textQuestion, window);
    % Start recall session for content of first learning session 
    mt_showText(dirRoot, textRecallImmediate, window);
    perc_correct = mt_cardGame(dirRoot, cfg_window, 1, 0, 5);
    mt_showText(dirRoot, strrep(textRecallPerformance, 'XXX', sprintf('%3.f', (100*perc_correct))), window);
    % Show final screen
    mt_showText(dirRoot, textOutro, window);
    sca;
    
% CONTROL BLOCKS
case cfg_cases.sesstype{4}
    % Show introduction screen
    mt_showText(dirRoot, textLearningControl, window);
    mt_showText(dirRoot, textQuestion, window);
    mt_controlTask(dirRoot, cfg_window);
    % Start recall session for content of first learning session 
    mt_showText(dirRoot, textRecallImmediate, window);
    perc_correct = mt_cardGame(dirRoot, cfg_window, 1, 0, 6);
    mt_showText(dirRoot, strrep(textRecallPerformance, 'XXX', sprintf('%3.f', (100*perc_correct))), window);
    % Show final screen
    mt_showText(dirRoot, textOutro, window);
    sca;
    
% ERROR CASE
case cfg_cases.sesstype{5}
    mt_fixationTask(dirRoot, fixRun);

otherwise
    sca;
    error('Invalid Session')
end

% Show final screen
ShowCursor(CursorType, window);
mt_showText(dirRoot, textOutro, window);
sca;
end