%%% Author: William Michael Mortl
%%% Feel free to use this code for educational purposes, any other use
%%%     requires citations to: William Michael Mortl, and
%%%     Sriram Sankaranaraynan

function [out_val] = noiseBoth(in_val)
    %%% function: noiseBoth
    %%% description: adds both white noise and dropouts
    %%% inputs:
    %%%     in_val - the glucose value in
    %%% outputs:
    %%%     out_val - the glucose value out

    %% just return the input value
    out_val = noiseDropout(noiseWhite(in_val));
end

