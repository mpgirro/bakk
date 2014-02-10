function [ bit, all_coef ] = extractbit( signalSegment )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% [decompositionVector,bookkeepingVector] = wavedec(signalSegment, Setting.getDwtLevel, Setting.getDwtWavelet);
% 
% % create unique class instances, therefore don't use repmat(Subband(),3,1)
% for i=1:Setting.SUBBAND_COUNT
%     S(i) = Subband();
% end
% 
% S(1).posArray = [ 1 : Setting.getSubbandLength ];
% S(2).posArray = [ Setting.getSubbandLength+1 : 2*Setting.getSubbandLength ];
% S(3).posArray = [ 2*Setting.getSubbandLength+1 : 3*Setting.getSubbandLength ];
% 
% for i=1:Setting.SUBBAND_COUNT
%     % copy corresponding coefficients
%     S(i).coefArray = decompositionVector(S(i).posArray(:));
%     
%     % we only sum up the absolute values, so apply abs() to every element
%     %S(i).coefArray = arrayfun(@abs,S(i).coefArray);
%     
%     % calculate the energy level
%      S(i).energy = sum(abs(S(i).coefArray(:)));
% end
% 
% [energyMap, strMap] = drawmaps(S);
% 
% Emin = strMap('min').energy;
% Emed = strMap('med').energy;
% Emax = strMap('max').energy;
% 
% % calculate energy difference 
% A = Emax - Emed; 
% B = Emed - Emin;

decomposition = signaldecomposition( signalSegment );
A = decomposition.A;
B = decomposition.B;

if A > B
    bit = 1;
else
    bit = 0;
end

% fprintf('Emin=%4f, Emed=%4f, Emax=%4f\n', Emin, Emed, Emax );
% max_coef = strMap('max').coefArray(:);
%all_coef = decompositionVector(1:3*Setting.getSubbandLength);
all_coef = decomposition.DecompositionVector(1:3*Setting.subband_length);

end

