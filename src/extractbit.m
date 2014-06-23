function [ bit ] = extractbit( signalSegment, frameLength )
% Extract the bit value encoded by the DWT coefficient subbands in a 
% signal segment
%
% Copyright (C) 2013-2014, Maximilian Irro <max@disposia.org>
%

window = 1:frameLength;

decomposition = signaldecomposition( signalSegment(window) );
A = decomposition.A;
B = decomposition.B;

if A > B
    bit = 1;
else
    bit = 0;
end

% -------------------------------
% ENABLE IF RUN WITH eval_decoder
%
% Emin = decomposition.Emin;
% Emed = decomposition.Emed;
% Emax = decomposition.Emax;
% fprintf('Bit: %2.2f | A: %2.2f | B: %2.2f | Emin: %2.2f | Emed: %2.2f | Emax: %2.2f\n', bit, A, B, Emin, Emed, Emax);
% -------------------------------

end

