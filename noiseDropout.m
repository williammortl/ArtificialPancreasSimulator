%%% Author: William Michael Mortl
%%% Feel free to use this code for educational purposes, any other use
%%%     requires citations to: William Michael Mortl, and
%%%     Sriram Sankaranaraynan

function [out_val] = noiseDropout(in_val)
    %%% function: noiseDropout
    %%% description: drops out the data to emulate sensor attenuation
    %%% inputs:
    %%%     in_val - the glucose value in
    %%% outputs:
    %%%     out_val - the glucose value out

    %% initialize dropped out
    persistent droppedOut;
    if isempty(droppedOut)
        droppedOut = false;
    end
    
    %% split logic on droppedOut
    out_val = 0;
    if (droppedOut == true)
        if (randi(evalin('base', 'DROPOUT_RESCUE')) == evalin('base', 'DROPOUT_RESCUE'))
            droppedOut = false;
            out_val = in_val;
        end
    else
        if (randi(evalin('base', 'DROPOUT_PROB')) == evalin('base', 'DROPOUT_PROB'))
            droppedOut = true;
        else
            out_val = in_val;
        end        
    end
end

