function [ bit ] = extractbit( signalSegment, frameLength )
%EXTRACTBIT Extract the bit value encoded by the dwt coefficient subbands
%in a signal segment
%   Detailed explanation goes here

% only take the samples used for the data, ignore the buffer zone
window = 1:frameLength;
%window = 1:Setting.frame_data_samples_length;

decomposition = signaldecomposition( signalSegment(window) );
A = decomposition.A;
B = decomposition.B;

if A > B
    bit = 1;
else
    bit = 0;
end


Emin = decomposition.Emin;
Emed = decomposition.Emed;
Emax = decomposition.Emax;

%fprintf('Bit: %2.2f | A: %2.2f | B: %2.2f | Emin: %2.2f | Emed: %2.2f | Emax: %2.2f\n', bit, A, B, Emin, Emed, Emax);

end

