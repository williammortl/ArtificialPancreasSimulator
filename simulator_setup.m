%%% Author: William Michael Mortl
%%% Feel free to use this code for educational purposes, any other use
%%%     requires citations to: William Michael Mortl, and
%%%     Sriram Sankaranaraynan

%%% This file contains the variables and constants that 
%%%     the simulator needs

%% clear the workspace first
clear;

%% meal generator constants
MIN_AGE = 5;
MAX_AGE = 80;
MEAN_BMI = 22;

%% meal bypass
MEAL_BYPASS = 0;                    % 0 - no bypass, 1 - use constants
MEAL_B_TIME = 480;                  % minutes into the day
MEAL_B_CARBS = 50;                  % carbs (grams)
MEAL_L_TIME = 720;
MEAL_L_CARBS = 50;
MEAL_D_TIME = 1050;
MEAL_D_CARBS = 50;

%% bergman minimal model, ins-glu response constants
P1 = .01;
P2 = .025;
P3 = 1.3*(10^-5);
VI = 12;
N = .093;
GB = 4.5;                           % mmol/L
IB0 = 15;                           % initial basal rate, U/L
IB = IB0;                           % BASAL RATE, U/L
G0 = 0;                             % mmol/L
X0 = 0;
I0 = 0.05;                          % U/L

%% noise constants
WHITE_NOISE_PERCENT = .1;
DROPOUT_PROB = 1440;                % Prob = 1 / DROPOUT_PROB
DROPOUT_RESCUE = 20;                % Prob = 1 / DROPOUT_RESCUE

%% variables for the artificial pancreas
% 0 - no controller
% 1 - the controller from assignment #5
% 2 - plugin controller, set by controllerFunction variable, function
%     must have the following prototype: 
%       [ui] = func_name(b_time, l_time, d_time, time, glucose)
SWITCH_ARTIFICIAL_PANCREAS = 2; 

%% function pointer variables
mealFunction = @mealNHanes;
noiseFunction = @noiseBoth;
controllerFunction = @humanBolus;