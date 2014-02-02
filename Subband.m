classdef Subband < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(SetAccess = public)  
        energy=0;       % Energy Level 
        coefArray = zeros(Setting.getSubbandLength);     % coefficients
        posArray  = zeros(Setting.getSubbandLength);     % Absolute Positions of the Coefficients in the Wavelet Coef Band
    end
        
end

