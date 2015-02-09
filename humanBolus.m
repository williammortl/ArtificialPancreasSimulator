%%% Author: William Michael Mortl
%%% Feel free to use this code for educational purposes, any other use
%%%     requires citations to: William Michael Mortl, and
%%%     Sriram Sankaranaraynan

function [ui] = humanBolus(b_time, l_time, d_time, time, glucose)
    %%% function: humanBolus
    %%% description: controls a person giving themselves a bolus, it is
    %%%              assumed that the wearer tells the artificial pancreas
    %%%              when they will eat 30 minutes prior
    %%% inputs:
    %%%     b_time - breakfast time (in minutes)
    %%%     l_time - lunch time (in minutes)
    %%%     d_time - dinner time (in minutes)
    %%%     time - the current time (in minutes)
    %%%     glucose - current blood glucose level (mmol/L)
    %%% outputs:
    %%%     ui - insulin U/L
    
    %% set init return value
    ui = 0;
    
    %% in case this is day n, adjust the time value to time of day
    time = mod(time, 1440);
    
    %% meals, they can overlap
    ui = insulinMealBolus(time - b_time, glucose);
    ui = ui + insulinMealBolus(time - l_time, glucose);
    ui = ui + insulinMealBolus(time - d_time, glucose);

end

function [ui] = insulinMealBolus(timeAfterMeal, glucose)
    %%% function: insulinMealBolus
    %%% description: how much insulin to release knowing a meal is
    %%%              upcoming, this is used by human Bolus
    %%% inputs:
    %%%     timeAfterMeal - the time after the meal (minutes)
    %%%     glucose - current blood glucose level (mmol/L)
    %%% outputs:
    %%%     ui - insulin U/L

    %% initial value
    ui = 0;
    
    %% calculate the amount of insulin to administer
    if (timeAfterMeal <= 70)
        if (timeAfterMeal >= 60)
            ui = 5 + (25/3 * expandingScalingFunction(glucose, 10));
        elseif (timeAfterMeal >= 50)
            ui = 10 + (25/3 * expandingScalingFunction(glucose, 10));
        elseif (timeAfterMeal >= 40)
            ui = 30 + (25/3 * expandingScalingFunction(glucose, 10));
        elseif (timeAfterMeal >= 30)
            ui = 80 + (25/3 * expandingScalingFunction(glucose, 10));
        elseif (timeAfterMeal >= 20)
            ui = 100 + (25/3 * expandingScalingFunction(glucose, 10));
        elseif (timeAfterMeal >= 10)
            ui = 100 + (25/3 * expandingScalingFunction(glucose, 10));
        elseif (timeAfterMeal >= 0)
            ui = 250 + (25/3 * expandingScalingFunction(glucose, 10));
        elseif (timeAfterMeal >= -10)
            ui = 200 + (25/3 * expandingScalingFunction(glucose, 10));
        elseif (timeAfterMeal >= -20)
            ui = 100 + (25/3 * expandingScalingFunction(glucose, 10));
        elseif (timeAfterMeal >= -30)
            ui = 150 + (25/3 * expandingScalingFunction(glucose, 10));
        end
    end
    
end

function [scale] = expandingScalingFunction(glucose, base)
    %%% function: expandingScalingFunction
    %%% description: an expanding scale that only grows greater than 100%
    %%% inputs:
    %%%     glucose - current blood glucose level (mmol/L)
    %%%     base - the value to base the scale on
    %%% outputs:
    %%%     scale - percentage... no lower that 1
    
    scale = max(1, glucose / base);
end

