function [ bit ] = extractbit( signalSegment )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

DWT_WAVELET = 'db2';
DWT_LEVELS = 6;
SUBBAND_LENGTH = 8;
SUBBAND_COUNT = 3;

[decompositionVector,bookkeepingVector] = wavedec(signalSegment, DWT_LEVELS, DWT_WAVELET);

% create unique class instances, therefore don't use repmat(Subband(),3,1)
for i=1:SUBBAND_COUNT
    S(i) = Subband();
end

S(1).posArray = [1 : SUBBAND_LENGTH];
S(2).posArray = [SUBBAND_LENGTH+1 : 2*SUBBAND_LENGTH];
S(3).posArray = [2*SUBBAND_LENGTH : 3*SUBBAND_LENGTH];

for i=1:SUBBAND_COUNT
    % copy corresponding coefficients
    S(i).coefArray = decompositionVector(S(i).posArray);
    
    % we only sum up the absolute values, so apply abs() to every element
    S(i).coefArray = arrayfun(@abs,S(i).coefArray);
    
    % calculate the energy level
    S(i).energy = sum(S(i).coefArray);
end

[energyMap, strMap] = drawmaps(S);

Emin = strMap('min').energy;
Emed = strMap('med').energy;
Emax = strMap('max').energy;

% calculate energy difference 
A = Emax - Emed; 
B = Emed - Emin;

if A > B
    bit = 1;
else
    bit = 0;
end

end

