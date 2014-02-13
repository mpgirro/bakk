function [ bit ] = extractbit( signalSegment )
%EXTRACTBIT Extract the bit value encoded by the dwt coefficient subbands
%in a signal segment
%   Detailed explanation goes here

decomposition = signaldecomposition( signalSegment );
A = decomposition.A;
B = decomposition.B;

if A > B
    bit = 1;
else
    bit = 0;
end

end

