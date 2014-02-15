function [ bit ] = extractbit( signalSegment )
%EXTRACTBIT Extract the bit value encoded by the dwt coefficient subbands
%in a signal segment
%   Detailed explanation goes here

% only take the samples used for the data, ignore the buffer zone
window = 1:Setting.frame_data_samples_length;

decomposition = signaldecomposition( signalSegment(window) );
A = decomposition.A;
B = decomposition.B;

if A > B
    bit = 1;
else
    bit = 0;
end

end

