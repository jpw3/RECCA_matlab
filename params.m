function [dp, sp] = params()
%% Author: James Wilmott, Spring 2019
%Experimental paramete specification file. Instantiates Psychtoolbox window
%and all experimental parameters as defined below into a host of objects,
%dp ('display parameters' and sp ('stimulus parameters'). This function is
%designed to be called by TrainingMain and TestMain, respectively.

%call the structures to be used as global
global display_params 
global stimulus_params

rng(now+rem(now,1)*1000+cputime*1000); %change the seed of the random number generator

%% Display Parameters
display_params.display_nr = max(Screen('Screens'));%2;  %screen number for use in opening window pointer, resolution calculation
display_params.pix_per_meter = 3779.528;


display_params.subj_dist     = ; %meters


computeDisplayParams(); %call this function (defined below) to define some variables that require measurements of the monitor
display_params.deg_height    = display_params.pix2deg*display_params.w_height; %convert pixel height into degrees
display_params.deg_width     = display_params.pix2deg*display_params.w_width;

display_params.pix_per_cm    = ; %41.6667; %for my mac


display_params.pix_per_deg   = display_params.deg2pix;
display_params.pixRect       = @degRect2Pix; %converts degree of visual angle (dva) rectangle to screen pixels. Note this is a function call, defined below
display_params.scrP2D        = @screenPt2Deg; %converts screen pixel coordinates to degrees of visual angle
display_params.D2scrP        = @getPixelCoordinates; %converts dva points to pixel coordinates
%Create the main display window
[display_params.winptr, display_params.rect] = Screen('OpenWindow', display_params.display_nr, 0); %Screen('OpenWindow',max(Screen('Screens')),0,[100,100,1820,980]);
[display_params.xCen, display_params.yCen] = RectCenter(display_params.rect);



end

