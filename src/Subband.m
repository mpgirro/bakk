classdef Subband < handle
% Subband properties class. 
%
% Copyright (C) 2013-2014, Maximilian Irro <max@disposia.org>
%
    
    properties(SetAccess = public)  
        energy    = 0;                              % Energy Level 
        coefArray = zeros(Setting.subband_length);  % coefficients
        posArray  = zeros(Setting.subband_length);  % Absolute Positions of the Coefficients in the Wavelet Coef Band
    end
        
end

