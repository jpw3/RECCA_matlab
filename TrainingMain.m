%% Author: James Wilmott, spring 2019
%For notes on use of this script in experiment pipeline, see that
%RECCA_READ_ME.txt file in the associated folder.

%In order to run this script, call 'TrainingMain' in the MATLAB interpreter
%when in the appropriate folder. Note, this script requires Psychtoolbox
%and the following MATLAB files to be installed:
%params() - funtcion to instantiate experiment parameters
%trainingTrial() - function that displays stimuli for each trial and
%collects response information

%MUST have called calibrate_tracker_new.m already to create a
%transformation matrix that will be used to adjust the retreived samples


%% First, start with a clean interpreter

%clear all; close all;

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


%% Run a block

%define nr of trials according to if 

block_type = 'TRAIN';
nr_trials = SP.TRAIN_nr_trials;

%redefine nr of trials if a practice block
if block_nr<1
    nr_trials = 'foo'; %how many trials should I give of pratice? Should I give monetary reward for these trials?
end


%% Put a cross on the screen
Screen('FillRect',DP.winptr,SP.background_lum); % fills the screen with the indicated color
Screen('FillRect',DP.winptr,SP.fix_lum,DP.pixRect([0,0,0.5,0.15])); 
Screen('FillRect',DP.winptr,SP.fix_lum,DP.pixRect([0,0,0.15,0.5]));
Screen('Flip', DP.winptr); % swaps front and back video buffers
 

%% Create schedule of trial types (pos. reward, neg. reward, no reward)for the upcoming block

%practice block has less trials, so different schedule
%do I need to define this differently though?
if block_nr < 0
    schedule = []; 
else
    schedule = []; %This will be len(nr of trials in a block)
end



%% Setup block and stimulus parameter structures that will be saved 
block.date = datestr(date, 'mmddyy'); %date
block.block_nr = block_nr;
block.sub_id = sub_id;
block.type = block_type;

%display params 
display_params.subject_distance = DP.subj_dist;
display_params.resolution_width = DP.w_width;
display_params.resolution_height = DP.w_height;

%stimulus params 
stimulus_params.nr_trials = SP.nr_trials;
stimulus_params.nr_blocks = SP.nr_blocks;
stimulus_params.soa = SP.soa;

block.sp = stimulus_params;
block.dp = display_params;

%create the filenames for data files 
mat_filename = sprintf('%s%s', 'RECCA_',block_type,'_', sub_id, '_', num2str(block_nr),'.mat'); %to save .mat file
txt_filename = sprintf('%s%s', 'RECCA_',block_type,'_', sub_id, '_', num2str(block_nr),'.txt'); %to save .mat file

%% Run Trials 
burn_trials=0; %trials to burn at the beginning of the block
invalids=0; %didn't move, took too long to move..? Will I make them repeat the trial?
iTrial=1;

% loop to run trials
while iTrial<=nr_trials   
    
    fprintf('CURRENT TRIAL NUMBER: %d\n', iTrial);
    fprintf('NUMBER OF INVALIDS: %d\n',invalids);
    fprintf('BURN TRIAL COUNT: %d\n\n', burn_trials);
    
    %get trial type according to the schedule above
    trial_type = schedule(iTrial);

    % Call the trial function to perform all stimulus presentation and response collection
    Priority(2); %increase priority for use in stimulus drawing in trial function
    
    [trial_results] = trainingTrial(trial_type, isTrain);

    Priority(0); %reset priority because no stimulus drawing
    
    % Record and save data appropriately  
    
    %Am I making participants repeat invalid trials??
%     %if an invalid trial throw the trial out and start fresh
%     if trial_results.abort_trial>0
%         invalids=invalids+1;
%         continue;
%     end

    %don't record burn trial data
    if burn_trials<SP.nr_burns
        burn_trials=burn_trials+1;
        continue
    end

    %record the data into existing holder arrays 
    %the data returned from the trial() function is a cell array, so must unpack 
    
    foo = 'bar';
    
    
    % save the data for this trial
    
    %This is how Jianfei does it. need to see what each variable
    %corresponds to and create the correct call to thses functions from my
    %data
%     % Write this trial's data to two files - exp. data and
%     % tracker data
%     for x = 1:length(SOT_data)
%         dlmwrite(strcat(pathdata,'\',subjNum,'_',num2str(currBlock),'_graspExp.txt'),...
%             [bb,i,SOT_data(x),xy1_data1(x),xy1_data2(x),xy2_data1(x),xy2_data2(x),currXYZ1_data1(x),currXYZ1_data2(x),currXYZ1_data3(x),currXYZ2_data1(x),currXYZ2_data2(x),currXYZ2_data3(x),currFrame_data(x)],'-append', 'roffset', [],'delimiter', '\t');
%     end
% 
%     %%%FIGURE THIS OUT: OUTPUT SPEED AND WIDTH DATA TO
%     %%%EASIER-TO-READ FILE
%     dlmwrite(strcat(pathdata,'\',subjNum,'_',num2str(currBlock),'_graspExp_block',num2str(bb),'.txt'),...
%         [bb, i, dstIndex(bb,i),ori1,ori2, reachedTo, timeElapsed, acc(bb,i), markerWait(bb,i)],'-append', 'roffset', [],'delimiter', '\t');
  
    %save data in .mat format
    save(strcat(directory, '/', mat_filename));
    
end

    
%% End the experiment

%save data in .mat format
save(strcat(directory, '/', mat_filename));

%Present a thank you screen
if block_nr==SP.nr_blocks
    Screen('FillRect',DP.winptr,SP.background_lum); % fills the screen with the indicated color
    DrawFormattedText(DP.winptr,'Thank you for your participation!','Center','Center',255);
    Screen('Flip', DP.winptr); % swaps front and back video buffers
    WaitSecs(3.0);
end

%close the Screen after use.
Screen('CloseAll');    
