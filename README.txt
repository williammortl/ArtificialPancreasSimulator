NHANES Meal Generator & Artificial Pancreas Simulator
by William Mortl



/ Introduction

This document contains an overview of the artificial pancreas simulator that I have built during the past year. The simulator uses the Bergman Minimal Model for modeling human insulin-glucose response and allows for detailed configuration and extensibility. Additionally, this simulator leverages the non-deterministic linear-approximation meal profile generator that was created from over a decade of data from the National Health and Nutrition Examination Survey (NHANES).

/ NHANES Meal Generator / Installation

This simulator requires the NHANES meal generator in order to function. Please pull the NHANES meal generator from:

https://github.com/williammortl/NHANES

and place it in a subdirectory named "NAHANES" inside the artificial pancreas simulator. After installing the NHANES meal generator, pelase continue reading through this file (or the README.txt file in the NHANES directory) in order to properly build the models which the NHANES meal generator relies upon to create meals.

/ NHANES Meal Generator / Overview

The NHANES linear-approximation meal profile generator is a non-deterministic model that generates 3 meals per day (including meal timing and composition) based upon biometric data describing an individual. It was determined that the 3 relevant biometric independent variables were: gender, age, and body mass index (BMI). The model yields meal values that are indicative of the eating patterns of individuals with similar biometric values within the NHANES data set.

Before creating the linear approximations (one model per meal variable, per meal, per gender), there were assumptions that needed to be made to simplify the models:

1.	Eliminate any tuples that have more than, or less than, 3 meals in a day.
2.	Eliminate any tuples that have non-western ethnic meals that could not be easily and accurately mapped to western meals.
3.	Ignore any and all data related to snacks.

Once all of the individual year data sets were cleansed, they were then consolidated into one dataset, and then subsequently re-weighted according to the tuple’s relative weight within the general population (this was given in the NHANES meal study). These consolidated datasets were then stored within the Matlab_Data subdirectory.

The Matlab data is then utilized by R code to generate the linear approximation models. These models are stored in a CSV format within the Models subdirectory. When simulating meals for an individual for a day, non-determinism is achieved by adding a random residual from the model being calculated.

/ NHANES Meal Generator / Model Creation

Before using the artificial pancreas simulator or re-using the NHANES based meal profile generator, it is imperative to generate all of the linear models that the generator uses. The instructions are as follows:
 
In R:
 
1.) Open buildModels.R.
2.) Change line 8 of the R code, this line sets the working directory for the R code. Alter it so that it points to the directory where the NHanes meal generator resides.
 
In Matlab:
 
3.) Run buildDataAndModels.m, this will take about 5 to10 minutes and will create directories Matlab_Data and Models.
 
The Matlab_Data directory will contain the following consolidated data files:
 
        mealsFiltered.mat          
        mealsFiltered.csv           
        mealsFilteredWeighted.mat  
        mealsFilteredWeighted.csv  
        consData.mat                
 
mealsFiltered.* contains consolidated data containing only days that contained 3 square meals.

mealsFilteredWeighted.* contains weighted adjusted consolidated data containing only days that contained 3 square meals

The Models directory contains CSV files that contain the coefficients for the linear approximation meal predictive models.
 
4.) To run a single simulation:
 
Usage: 

simulateDay({'M' | 'F'}, {age}, {body mass index})

Example:

output = simulateDay('M', 37, 32.5)
 
5.) To perform multiple simulations:

Usage: 

runMultipleSimulations({number of days to simulate})

Exmaple:

sims = runMultipleSimulations(1000);
 
In order to use the meal simulator as part of another project, you need the following files and directories (including their contents):
 
Matlab_Data\
Models\
daySimulator.m
linearModel.m
mealModel.m
simulateDay.m
runMultipleSimulations.m		(optional, only if needed)

/ NHANES Meal Generator / Output Columns

Column Number - Column Contents
1 - Person ID
2 - Age
3 - Gender
4 - Weight (only if provided)
5 - BMI
6 - Relative Weighting
7 - Breakfast Carbs (g)
8 - Breakfast Protein (g)
9 - Breakfast Fiber (g)
10 - Breakfast Total Fat (g)
11 - Breakfast Size (g)
12 - Breakfast Calories (kcal)
13 - Breakfast Time (minutes from midnight)
14 - Lunch Carbs (g)
15 - Lunch Protein (g)
16 - Lunch Fiber (g)
17 - Lunch Total Fat (g)
18 - Lunch Size (g)
19 - Lunch Calories (kcal)
20 - Lunch Time (minutes from midnight)
21 - Lunch Minutes Since Breakfast
22 - Dinner Carbs (g)
23 - Dinner Protein (g)
24 - Dinner Fiber (g)
25 - Dinner Total Fat (g)
26 - Dinner Size (g)
27 - Dinner Calories (kcal)
28 - Dinner Time (minutes from midnight)
29 - Dinner Minutes Since Breakfast
30 - Dinner Minutes Since Lunch

/ NHANES Meal Generator / Future Work

This meal generator is a useful tool, however, it certainly has its limitations. First of all while building the models, all tuples of data containing less than 3 traditional western meals were removed from consideration. Additionally for tuples with 3 meals, all snacks were removed from consideration. This means that the linear approximation models do not adequately express scenarios where individuals eat less than 3 meals. Also, the meal generator does not generate snacks or any meals that exist outside of the traditional 3 American meals.
To more adequately represent the data, the next version of the meal generator should use the data in a different manner to generate zero to n meals as well as generate zero to n snacks. This functionality was left out in the first version of the meal generator for the sake of simplicity.

To implement multiple meals, the data needs to be parsed to determine how many meals were eaten in a day, and then regress on an individual’s biometric data to predict this number. The same sort of logic could be applied to snacks. An alternative methodology would be to use a hidden Markov model to predict a meal/snack from the previous meals/snacks.

/ Simulator / Overview

The simulator is highly extensible and integrates with and makes use of the NHANES meal generator. The simulator uses the Bergman Minimal Model to emulate the human insulin-glucose response mechanism. Additionally, I have re-implemented a simple artificial pancreas controller from assignment 5 of CSCI 7000 at CU Boulder. Additionally I have created a new bolus controller that assumes that an individual pushes a button 30 minutes prior to consuming a meal.

The simulator also models sensor noise in two different ways: one, it adds a configurable amount of white noise to the glucose value, and two, it models sensor attenuation dropouts and rescue by way of configurable probability values.

/ Simulator / Configuration & Extensibility

The simulator can be configured to run various time intervals (each clock tick is equal to one minute), of special interest is the color coding of subsystems on the main simulator screen:

BLUE – only executed once per simulation regardless of how long of a simulation is chosen. These blocks randomly select an individual (age, gender, and body mass index)

GREEN – these blocks execute once every 1440 ticks. This is equivalent to once every 1440 minutes, or once a day.

MAGENTA – these blocks execute every tick (or minute). These blocks comprise the artificial pancreas and the human glucose-insulin response.

YELLOW – these blocks comprise the output of the system.

The simulator is configured entirely through the simulator_setup.m file. The configuration parameters are:

Variable Name - Purpose

MIN_AGE - The minimum age randomly generated
MAX_AGE - The max age randomly generated
MEAN_BMI - The mean BMI for the BMI generator
MEAL_BYPASS - Do not use meal generator, use hard coded meal values
MEAL_B_TIME - Hardcoded breakfast time
MEAL_B_CARBS - Hardcoded breakfast carbs
MEAL_L_TIME - Hardcoded lunch time
MEAL_L_CARBS - Hardcoded lunch carbs
MEAL_D_TIME - Hardcoded dinner time
MEAL_D_CARBS - Hardcoded dinner carbs
P1, P2, P3, VI, N - Constants for the Berman Minimal Model
GO, XO, IO - Initial values for integrators for the Bergman Minimal Model
IB0, IB - The initial basal rate (constant), and the basal rate (varies)
WHITE_NOISE_PERCENT - For the white noise generator, percent of current value that the noise cannot exceed
DROPOUT_PROB - The probability of a dropout ocurring
DROPOUT_RESCUE - The probability of a dropout ending
SWITCH_ARTIFICIAL_PANCREAS - This switches which controller to use:
	0 – No Controller
	1 – The controller from assignment #5
	2 – Plugin controller, executes the function pointed to by controllerFunction
mealFunction - Function pointer, points to meal generator function
noiseFunction - Function pointer, points to the noise function being used to make the glucose data more noisy
controllerFunction - Function pointer, if SWITCH_ARTIFICIAL_PANCREAS is set to 2 this function is executed as the controller

Included with this simulator is a meal absorption function based upon the 5th assignment of CSCI 7000 that works seamlessly with the Bergman Minimal Model. It is possible to bypass the NHANES generated meal values and force the simulator to use hard-coded meal values from constants. This occurs when MEAL_BYPASS is set to 1, then the meal values are extracted from the MEAL_* variables.

I have included four noise functions: a function that does not add any noise to the glucose value, a function that adds white noise, a function that adds dropouts that emulate sensor attenuation, and finally, a function that combines white noise and dropouts. 

I have created only one plug-in controller function, humanBolus.m. Setting SWITCH_ARTIFICIAL_PANCREAS to 2 activates this plug-in controller. This function acts as if the user pushes a button 30 minutes prior to a meal, and then uses this timing to bolus insulin. 

The simulator is extensible via the 3 function pointer variables. The simulator calls the functions pointed to by these variables. The prototypes that functions need to implement to work properly with the simulator are as follows:

mealFunction:

[ug] = {meal function}(mealTime, mealSize, actualTime)
    %%% function: {meal function}
    %%% description: handles how the meal is absorbed
    %%% inputs:
    %%%     mealTime - meal time (minutes)
    %%%     mealSize - carbs (grams)
    %%%     actualTime - the time of day (minutes)
    %%% outputs:
    %%%     ug - the glucose value out (gm/min)

noiseFunction:

[out_val] = {noise function}(in_val)
    %%% function: {noise function}
    %%% description: adds noise to the data
    %%% inputs:
    %%%     in_val - the glucose value in
    %%% outputs:
    %%%     out_val - the glucose value out

controllerFunction:

[ui] = {controller func}(b_time, l_time, d_time, time, glucose)
    %%% function: {controller func}
    %%% description: controls insulin bolus
    %%% inputs:
    %%%     b_time - breakfast time (in minutes)
    %%%     l_time - lunch time (in minutes)
    %%%     d_time - dinner time (in minutes)
    %%%     time - the current time (in minutes)
    %%%     glucose - current blood glucose level (mmol/L)
    %%% outputs:
    %%%     ui - insulin U/L

For more details about the simulator configuration, please see the comments in simulator_setup.m.

/ Simulator / Output

The simulator outputs data to a file named DataFile.mat. This file contains 4 row vectors with data from the simulation run:

Row Number - Row Contents
1 - Time (minutes)
2 - Meal glucose contribution
3 - Blood-glucose level (mmol/L)
4 - Insulin, above basal (U/L)

Additionally, there are many scopes available in the Simulink model for the simulator that can be examined.
 
/ Simulator / Future Work & Errata

Future work on this simulator should include adding a Dalla Man model based human insulin-glucose response mechanism as well as a switch. It should be configurable which response mechanism to use. 

Additionally, as stated earlier, the NHANES meal generator should be altered so that it can generate 0 to n meals per day, as well as generate snacks. This would yield a much more realistic meal profile. 

/ Citations

1.	Bergman, Richard N. "Toward physiological understanding of glucose tolerance: minimal-model approach." Diabetes 38.12 (1989): 1512-1527.

2.	Buckingham, Bruce A., et al. "Outpatient safety assessment of an in-home predictive low-glucose suspend system with type 1 diabetes subjects at elevated risk of nocturnal hypoglycemia." Diabetes technology & therapeutics 15.8 (2013): 622-627.

3.	Centers for Disease Control and Prevention (CDC). National Center for Health Statistics (NCHS). National Health and Nutrition Examination Survey Data. Hyattsville, MD: U.S. Department of Health and Human Services, Centers for Disease Control and Prevention, 1999-2011 http://www.cdc.gov/nchs/nhanes/nhanes_questionnaires.htm.

