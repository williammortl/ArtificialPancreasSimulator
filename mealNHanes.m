%%% Author: William Michael Mortl
%%% Feel free to use this code for educational purposes, any other use
%%%     requires citations to: NHanes study, William Michael Mortl,
%%%     Sriram Sankaranaraynan, and Fraser Cameron

function [mealData] = mealNHanes(genderNum, age, BMI)
    %%% function: mealNHanes
    %%% description: calls NHanes/simulateDay which wraps the daySimulator 
    %%%     class, must have the data file
    %%%     'mealsFilteredWeighted.mat' in the 'Matlab_Data' subdirectory.
    %%%     Also, this function requires: 'daySimulator.m', 'mealModel.m', and
    %%%     'linearModel.m' to be in the same directory. Additionally, this
    %%%     function requires that all linear models have been generated and
    %%%     are present in the 'Models' subdirectory
    %%% inputs:
    %%%     genderCode - 0 for 'M' or 1 for 'F'
    %%%     age - the age
    %%%     BMI - the body mass index
    %%% outputs:
    %%%     this is in columns
    %%%     1 - breakfast time (in minutes)
    %%%     2 - breakfast carbs (in grams)
    %%%     3 - lunch time (in minutes)
    %%%     4 - lunch carbs (in grams)
    %%%     5 - dinner time (in minutes)
    %%%     6 - dinner carbs (in grams)
    
    %% adjust gender code... 0 = M, else F
    genderCode = 'M';
    if (genderNum ~= 0)
        genderCode = 'F';
    end
    
    %% cd into NHanes, call code
    cd NHANES;
    rawData = simulateDay(genderCode, age, BMI);
    cd ..;

    %% format output to only the data we want
    mealData = zeros(1, 6);
    mealData(1, 1) = rawData(1, 13);
    mealData(1, 2) = rawData(1, 7);   
    mealData(1, 3) = rawData(1, 20);
    mealData(1, 4) = rawData(1, 14);
    mealData(1, 5) = rawData(1, 28);
    mealData(1, 6) = rawData(1, 22);
end

