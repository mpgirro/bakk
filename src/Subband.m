classdef Subband < handle
% Subband properties class. 
    
    properties(SetAccess = public)  
        energy    = 0;                              % Energy Level 
        coefArray = zeros(Setting.subband_length);  % coefficients
        posArray  = zeros(Setting.subband_length);  % Absolute Positions of the Coefficients in the Wavelet Coef Band
    end
        
end

