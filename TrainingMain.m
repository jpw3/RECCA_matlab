%% Author: James Wilmott, spring 2019
%For notes on use of this script in experiment pipeline, see that
%RECCA_READ_ME.txt file in the associated folder.

%In order to run this script, call 'TrainingMain' in the MATLAB interpreter
%when in the appropriate folder. Note, this script requires Psychtoolbox
%and the following MATLAB files to be installed:
%params() - funtcion to instantiate experiment parameters
%trainingTrial() - function that displays stimuli for each trial and
%collects response information


%% First, start with a clean interpreter

clear all; close all;

%% Prompt for input
sub_id = input('Subject number: ', 's');

%% Compute and load global parameters from params()
global DP; %Display parameters
global SP; %Stimulus parameters

%Initialize DP and SP structures
[DP, SP] = params(); 

%Give meaning to the keys
KbName('UnifyKeyNames'); 

% Perform basic initialization of the sound driver:
InitializePsychSound(1);
PsychPortAudio('Verbosity',1);

%Gets rid of warnings and blue flash when opening a Screen
Screen('Preference', 'VisualDebugLevel', 3);
Screen('Preference', 'SuppressAllWarnings');

%% Test refresh rate
fprintf('\n...testing refresh rate...\n');
nr_flips = 100;
flip_times = zeros(nr_flips,1);
start_time = GetSecs;
for i=1:nr_flips
    Screen('FillRect',DP.winptr,SP.background_lum);
    Screen('Flip', DP.winptr);
    flip_times(i) = GetSecs-start_time;
end
empirical_refresh_rate = 1/mean(diff(flip_times(2:end)));
DP.frame_rate = empirical_refresh_rate;
display_params.frame_rate = DP.frame_rate;
fprintf('Empirical refresh rate: %2.2f Hz\n', empirical_refresh_rate);

%% Initialize relevant aspects
directory = sprintf('%s%s', '', sub_id); %set up for use on lab computer

% The directory for ET room: C:/Documents and Settings/Eyelink/Desktop/james/MATLAB/data/ratio_nt/

if ~exist('parentDirectory', 'dir')
    mkdir(directory);
end

%% Here, either create an example trial for the participants, or else find another way of explaining the task to them




