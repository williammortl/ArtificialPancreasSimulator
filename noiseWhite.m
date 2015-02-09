%%% Author: William Michael Mortl
%%% Feel free to use this code for educational purposes, any other use
%%%     requires citations to: William Michael Mortl, and
%%%     Sriram Sankaranaraynan

function [out_val] = noiseWhite(in_val)
    %%% function: noiseWhite
    %%% description: returns glucose fudged with white noise between
    %%%              +- (WHITE_NOISE_PERCENT * in_val)
    %%% inputs:
    %%%     in_val - the glucose value in
    %%% outputs:
    %%%     out_val - the glucose value out

    %% bound
    bound = evalin('base', 'WHITE_NOISE_PERCENT') * in_val;
    
    %% noise
    noise = bound + (bound - (-1 * bound)).*rand(1);
    
    %% just return the input value
    out_val = in_val + noise;
end

