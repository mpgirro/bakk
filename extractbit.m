function [ bit ] = extractbit( signalSegment )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[decompositionVector,bookkeepingVector] = wavedec(signalSegment, AlgoConst.DWT_LEVELS, AlgoConst.DWT_WAVELET);

% create unique class instances, therefore don't use repmat(Subband(),3,1)
for i=1:AlgoConst.SUBBAND_COUNT
    S(i) = Subband();
end

S(1).posArray = [1 : AlgoConst.SUBBAND_LENGTH];
S(2).posArray = [AlgoConst.SUBBAND_LENGTH+1 : 2*AlgoConst.SUBBAND_LENGTH];
S(3).posArray = [2*AlgoConst.SUBBAND_LENGTH+1 : 3*AlgoConst.SUBBAND_LENGTH];

for i=1:AlgoConst.SUBBAND_COUNT
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

