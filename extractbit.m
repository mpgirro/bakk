function [ bit, all_coef ] = extractbit( signalSegment )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


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

