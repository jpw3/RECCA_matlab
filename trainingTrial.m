function [trial_results] = trainingTrial(trial_type)
%This is a trial instance for a Trainign trial in the RECCA experiment
%Input arguments:
%Ouput structure is a cell array consisting of the relevant data from this
%trial

%% Set up trial
global DP;
global SP; 

KbName('UnifyKeyNames'); %give meaning to keyboard names

%Set up trial by getting trial parameters 
%calling a locally defined function below to do this
trial_params = getParams(trial_type); %need to code this up still



%draw the lines corresponding to the appropriate location
% Screen('DrawLines', DP.winptr, XY, [,width], [,colors], [,center]); %xy
% is a 2-row vector containing the x and y coordinates, where each collumn
% corresponds to the x and y position of a line. so XY(1,1) = x coor of the
% first line, XY(2,1) = y coor of the first line, etc. All positions are
% relative to 'center' (default is [0,0])



%% Display pre-trial fixation. 
Screen('FillRect',DP.winptr,SP.background_lum);
Screen('FillRect',DP.winptr,SP.fix_lum,DP.pixRect([0,0,0.5,0.15])); 
Screen('FillRect',DP.winptr,SP.fix_lum,DP.pixRect([0,0,0.15,0.5]));
Screen('DrawingFinished',DP.winptr);
Screen('Flip',DP.winptr);

%% Wait for the stimulus display to come up before allowing participant to move finger

start_measure = GetSecs();
while (start_measure - GetSecs) < SP.soa
    
    %'listen' to the reach tracker, checking the returned sample against
    
    %get sample
    
    %check if the finger has moved.. break from the trial if so
    if (sample > allowable_distance)
       abort = 1;
       break;
    end

end

%% Start Stimulus Presentation 

% probably cut the fixation cross for just a blank scree, check the RECCA
% presentation poerpoint


%% Draw Stimulus Presentation

%Create the stimulus display according to trial_params. 



%% Collect response, give feedback, and add relevant data to trial results

%monitor the reach position throughout the trial. Decode the response from
%the end location 

%SAVE all data


%redraw fixation cross after the trial is over
%redraw just the fixation to get rid of the shapes
Screen('FillRect',DP.winptr,SP.background_lum);
Screen('FillRect',DP.winptr,SP.fix_lum,DP.pixRect([0,0,0.5,0.15])); %fixation cross
Screen('FillRect',DP.winptr,SP.fix_lum,DP.pixRect([0,0,0.15,0.5]));
Screen('DrawingFinished',DP.winptr);
Screen('Flip',DP.winptr);




end

function [params] = getParams(trial_type)
global SP;
 %% returns the relevant trial paramters for this given trial
 
 %define common parameters for all trial types here
 
 %use a switch statement to define trial parameters that are unique to each
 %trial type
 switch trial_type  
     case 1
         
     case 2
         
         %etc...
         
 end
 
end