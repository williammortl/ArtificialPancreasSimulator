%%% Author: William Michael Mortl
%%% Feel free to use this code for educational purposes, any other use
%%%     requires citations to: William Michael Mortl, and
%%%     Sriram Sankaranaraynan

function [ug] = mealAbsorption(mealTime, mealSize, actualTime)
    %%% function: mealAbsorption
    %%% description: handles how the meal is absorbed
    %%% inputs:
    %%%     mealTime - meal time (minutes)
    %%%     mealSize - carbs (grams)
    %%%     actualTime - the time of day (minutes)
    %%% outputs:
    %%%     ug - the glucose value out (gm/min)
    
    %% in case this is day n, adjust the time value to time of day
    actualTime = mod(actualTime, 1440);
    
    %% get the time after the meal
    time = actualTime - mealTime;
    
    %% get percentage
    if (time <= 10)
        ug = 0;
    elseif (time <= 20)
        ug = .07;
    elseif (time <= 30)
        ug = .14;
    elseif (time <= 40)
        ug = .21;
    elseif (time <= 50)
        ug = .18;
    elseif (time <= 60)
        ug = .07;
    elseif (time <= 70)
        ug = .03;
    else
        ug = 0;
    end

    %% determine ug... in gm/min
    ug = ug * mealSize / 10;
    
end

