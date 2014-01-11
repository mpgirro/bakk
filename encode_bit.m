function [ modifiedSignalSegment ] = encode_bit( originalSignalSegment, bit )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%
%   

DWT_WAVELET = 'db2';
DWT_LEVELS = 6;
SUBBAND_LENGTH = 8;
SUBBAND_COUNT = 3;

% embedding strength factor
esf = 3;

[decompositionVector,bookkeepingVector] = wavedec(originalSignalSegment, DWT_LEVELS, DWT_WAVELET);



% create unique class instances, therefore don't use repmat(Subband(),3,1)
for i=1:SUBBAND_COUNT
    S(i) = Subband();
end

S(1).positionArray = [1 : SUBBAND_LENGTH];
S(2).positionArray = [SUBBAND_LENGTH+1 : 2*SUBBAND_LENGTH];
S(3).positionArray = [2*SUBBAND_LENGTH : 3*SUBBAND_LENGTH];

for i=1:SUBBAND_COUNT
    % copy corresponding coefficients
    S(i).coefficientArray = decompositionVector(S(i).positionArray);
    
    % we only sum up the absolute values, so apply abs() to every element
    S(i).coefficientArray = arrayfun(@abs,S(i).coefficientArray);
    
    % calculate the energy level
    S(i).energy = sum(S(i).coefficientArray);
end

[energyMap, stringMap] = drawmaps(S);

Emin = stringMap('min').energy;
Emed = stringMap('med').energy;
Emax = stringMap('max').energy;

% calculate energy difference 
A = Emax - Emed; 
B = Emed - Emin;


% emb_str...embedding strength (S im paper)
%emb_str = (esf * sum( C(1:3*SUBBAND_LENGTH) )) / 3; 
emb_str = 2*Emed/(Emed+Emax) * (Emax-Emin)
esf = 3*emb_str/sum( decompositionVector(1:3*SUBBAND_LENGTH))


insertion = false;

if bit == 1 && A-B < emb_str
    
    insertion = true;
    
    fprintf('A-B=%d\n',A-B);
    
    % we have to modify the coefficients
    
    xi = abs(emb_str-A+B);
    
    % precalculate the alteration factors to the coefficients
    % these are static and not influenced by the c(i)
    f_minmax = 1 + xi/(Emax + 2*Emed + Emin);
    f_med = 1 - xi/(Emax + 2*Emed + Emin);
    
elseif bit == 0 && B - A <= emb_str
    
    insertion = true;
    fprintf('B-A=%d\n',B-A);
    
    xi = abs(emb_str+A-B);
    
    % precalculate the alteration factors to the coefficients
    % these are static and not influenced by the c(i)
    f_minmax = 1 - xi/(Emax + 2*Emed + Emin);
    f_med = 1 + xi/(Emax + 2*Emed + Emin);
        
else
    % we do absoluteley nothing
end

if(insertion)
    Smin = stringMap('min');
    Smed = stringMap('med');
    Smax = stringMap('max');
    for i=1:SUBBAND_LENGTH
        Smin.coefficientArray(i) = Smin.coefficientArray(i) * f_minmax;
        Smed.coefficientArray(i) = Smed.coefficientArray(i) * f_med;
        Smax.coefficientArray(i) = Smax.coefficientArray(i) * f_minmax;
    end
    
    modDecompositionVector = decompositionVector;
    for i=1:SUBBAND_LENGTH
        modDecompositionVector(S(1).positionArray(i)) = S(1).coefficientArray(i);
        modDecompositionVector(S(2).positionArray(i)) = S(2).coefficientArray(i);
        modDecompositionVector(S(3).positionArray(i)) = S(3).coefficientArray(i);
    end
    
    %diff_C = C - mod_C;
    %plot(diff_C(1:3*SUBBAND_LENGTH));

    modifiedSignalSegment = waverec(modDecompositionVector, bookkeepingVector, DWT_WAVELET);
else
    modifiedSignalSegment = originalSignalSegment;
end

end

