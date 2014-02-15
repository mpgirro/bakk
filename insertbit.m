function [ modSignalSegment ] = insertbit( origSignalSegment, bit )
%INSERTBIT Modify a signal segment to encode one bit
%   Detailed explanation goes here
%
%

% only take the samples used for the data, ignore the buffer zone
window = 1:Setting.frame_data_samples_length;

% decompose the segment. all this stuff we need to modify the signal
decomposition = signaldecomposition( origSignalSegment(window) );
Emin = decomposition.Emin;
Emed = decomposition.Emed;
Emax = decomposition.Emax;
A = decomposition.A;
B = decomposition.B;
subbandMap = decomposition.SubbandMap;
decompositionVector = decomposition.DecompositionVector;
bookkeepingVector = decomposition.BookkeepingVector;

% embedding strength factor
esf = Setting.embedding_strength_factor;

% ES...embedding strength (S im paper)
ES = (esf * sum(abs(decompositionVector(1:3*Setting.subband_length)) )) / 3;

% satisfy equation (11)
if ES >= 2*Emed / (Emed+Emin) * (Emax-Emin)
    ES = 2*Emed / (Emed+Emin) * (Emax-Emin);
end

% satisfy equation (8)
if ES >= 2*Emed / (Emed+Emax) * (Emax-Emin)
    ES = 2*Emed / (Emed+Emax) * (Emax-Emin);
end


% THIS IS A SECURITY MARGIN OF MY OWN DESIGN
% to make sure that E'med < E'max
% if not, it could be that E'med = E'max
ES = ES - 0.1*ES;

insertion = false;

if bit == 1 && A-B >= ES
    %do nothing - bit '1' can already logically encoded
elseif bit == 0 && B-A >= ES
    %do nothing - bit '0' can already logically encoded
else
    
    % engery level differences do not satisfy the logic yet
    % we need to do some adjustments
    
    if bit == 1 && A-B < ES
        
        insertion = true;
        
        xi = abs(ES-A+B);
        
        % precalculate the alteration factors to the coefficients
        % these are static and not influenced by the c(i)
        factorMinMax = 1 + xi/(Emax + 2*Emed + Emin);
        factorMed 	 = 1 - xi/(Emax + 2*Emed + Emin);
        
    elseif bit == 0 && B-A < ES
        
        insertion = true;
        
        xi = abs(ES+A-B);
        
        % precalculate the alteration factors to the coefficients
        % these are static and not influenced by the c(i)
        factorMinMax = 1 - xi/(Emax + 2*Emed + Emin);
        factorMed 	 = 1 + xi/(Emax + 2*Emed + Emin);
    else
        fprintf('Oh boy, there is something really wrong here\n');
    end
end


if(insertion)
    
    % now we need the subbands matching the engery values
    Smin = subbandMap('min');
    Smed = subbandMap('med');
    Smax = subbandMap('max');
    
    % modify the coefficient to match the constraint of the bit to encode
    Smin.coefArray(:) = Smin.coefArray(:) .* factorMinMax;
    Smed.coefArray(:) = Smed.coefArray(:) .* factorMed;
    Smax.coefArray(:) = Smax.coefArray(:) .* factorMinMax;
    
    modDecompositionVector = decompositionVector;
    
    modDecompositionVector(Smin.posArray(:)) = Smin.coefArray(:);
    modDecompositionVector(Smed.posArray(:)) = Smed.coefArray(:);
    modDecompositionVector(Smax.posArray(:)) = Smax.coefArray(:);
    
    
    dataSignalSegment = waverec(modDecompositionVector, bookkeepingVector, Setting.dwt_wavelet);
    
else
    dataSignalSegment = origSignalSegment;
end

% return the modified data samples + buffer zone samples
modSignalSegment = origSignalSegment;
modSignalSegment(window) = dataSignalSegment(window);


end

