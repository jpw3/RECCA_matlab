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
display_params.subj_dist     = 0.60; %meters
computeDisplayParams(); %call this function (defined below) to define some variables that require measurements of the monitor
display_params.deg_height    = display_params.pix2deg*display_params.w_height; %convert pixel height into degrees
display_params.deg_width     = display_params.pix2deg*display_params.w_width;
display_params.pix_per_cm    = 22.8; %41.6667; % for baclit Plexiglass display, for my mac
display_params.pix_per_deg   = display_params.deg2pix;
display_params.pixRect       = @degRect2Pix; %converts degree of visual angle (dva) rectangle to screen pixels. Note this is a function call, defined below
display_params.scrP2D        = @screenPt2Deg; %converts screen pixel coordinates to degrees of visual angle
display_params.D2scrP        = @getPixelCoordinates; %converts dva points to pixel coordinates

%Create the main display window
[display_params.winptr, display_params.rect] = Screen('OpenWindow', display_params.display_nr, 0); %Screen('OpenWindow',max(Screen('Screens')),0,[100,100,1820,980]);
[display_params.xCen, display_params.yCen] = RectCenter(display_params.rect);

%% Stimulus Parameters
%Common parameters for both TRAIN and TEST phases
stimulus_params.pos_reward_value = 10; %cents
stimulus_params.neg_reward_value = -5; %cents
stimulus_params.no_reward_value = 0; %cents
stimulus_params.reward_prob = 0.8; %80% probability of getting the associated reward, else they receive 0

%TRAIN specific parameters
stimulus_params.TRAIN_nr_trials = 30; %per block
stimulus_params.TRAIN_nr_blocks = 4;




%TEST specific parameters
stimulus_params.TEST_nr_trials = 72;
stimulus_params.TEST_nr_blocks = 5;


end

%% Miscellaneous function definitions
%computes and assigns some important variables based on computer and monitor parameters
function computeDisplayParams()
    global display_params;
    scrn_res = Screen('Resolution',display_params.display_nr);
    display_params.w_width = scrn_res.width;
    display_params.w_height = scrn_res.height;
    
    %% below, I'm assuming that the the screen pixels are square (in aggregate)
    screen_diag_pix = sqrt(display_params.w_width^2+display_params.w_height^2);
    display_params.display_diag  = screen_diag_pix/display_params.pix_per_meter; %meters
    screen_diag_deg = 2*atand(0.5*display_params.display_diag/display_params.subj_dist);
    display_params.deg2pix = screen_diag_pix/screen_diag_deg; 
    display_params.pix2deg = 1/display_params.deg2pix;
end

function pix_rect = degRect2Pix(deg_rect)
    % converts a [x_center,y_center,width,height] deg VA rectangle to the
    % [u,l,b,r] screen pixel format required by various Screen() functions 
    global display_params;
    D2P = display_params.deg2pix;
    WW = display_params.w_width;
    WH = display_params.w_height;
    
    pix_rect(1) = deg_rect(1)*D2P+0.5*(WW-deg_rect(3)*D2P);
    pix_rect(3) = pix_rect(1)+deg_rect(3)*D2P;
    pix_rect(2) = 0.5*(WH-deg_rect(4)*D2P)-deg_rect(2)*D2P;
    pix_rect(4) = pix_rect(2)+deg_rect(4)*D2P;
    pix_rect = round(pix_rect);
end

function pt = screenPt2Deg(x,y)
    % converts a point specified in deg VA (from screen center) to screen pixels
    global display_params;
    P2D = display_params.pix2deg;
    WW = display_params.w_width;
    WH = display_params.w_height;
    xdeg = (x-0.5*WW)*P2D;
    ydeg = (0.5*WH-y)*P2D;
    pt = [xdeg,ydeg];
end

function [pix_array] =  getPixelCoordinates(dva_coor_array)
    %takes an array of dva screen coordinates and returns the corresponding pixel coordinate array
    %designed to be called on a 1 by 2 matrix
    global display_params;
    pix_array = [0,0];

    %get the x, y coordinates together in pixels. If either is negative, this should still capture those values
    x = (display_params.w_width/2)+(display_params.pix_per_deg*dva_coor_array(1));
    y = (display_params.w_height/2)-(display_params.pix_per_deg*dva_coor_array(2)); %subtract for Y values
    pix_array(1)=x; pix_array(2)=y; %assign the transformed value to this array 

end
