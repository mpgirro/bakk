function [ modSignalSegment ] = encode_bit( origSignalSegment, bit )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%
%   

DWT_WAVELET = 'db2';
DWT_LEVELS = 6;
SUBBAND_LENGTH = 8;
SUBBAND_COUNT = 3;

[decompositionVector,bookkeepingVector] = wavedec(origSignalSegment, DWT_LEVELS, DWT_WAVELET);

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



% emb_str = 2*Emed/(Emed+Emax) * (Emax-Emin);
% esf = 3*emb_str/sum( decompositionVector(1:3*SUBBAND_LENGTH));

% embedding strength factor
esf = 2;

    
% emb_str...embedding strength (S im paper)
emb_str = (esf * sum( decompositionVector(1:3*SUBBAND_LENGTH) )) / 3;
if (emb_str <= 2*Emed/(Emed+Emax) * (Emax-Emin)) == false
    emb_str = 2*Emed/(Emed+Emax) * (Emax-Emin);
    esf = 3*emb_str/sum( decompositionVector(1:3*SUBBAND_LENGTH));
end

insertion = false;

if bit == 1 && A-B >= emb_str
    %do nothing - bit '1' can already be seen as encoded
elseif bit == 0 && B-A >= emb_str
    %do nothing - bit '0' can already be seen as encoded
else
    
    % engery level differences do not satisfy the logic yet
    % we need to do some adjustments
    
    if bit == 1
    
        insertion = true;
        
        %     fprintf('A-B=%d\n',A-B);
        
        % we have to modify the coefficients
        
        xi = abs(emb_str-A+B);
        
        % precalculate the alteration factors to the coefficients
        % these are static and not influenced by the c(i)
        factorMinMax = 1 + xi/(Emax + 2*Emed + Emin);
        factorMed = 1 - xi/(Emax + 2*Emed + Emin);
    
    elseif bit == 0
    
        insertion = true;
        %     fprintf('B-A=%d\n',B-A);
        
        xi = abs(emb_str+A-B);
        
        % precalculate the alteration factors to the coefficients
        % these are static and not influenced by the c(i)
        factorMinMax = 1 - xi/(Emax + 2*Emed + Emin);
        factorMed = 1 + xi/(Emax + 2*Emed + Emin);
    end
end

if(insertion)
    Smin = strMap('min');
    Smed = strMap('med');
    Smax = strMap('max');
    for i=1:SUBBAND_LENGTH
        Smin.coefArray(i) = Smin.coefArray(i) * factorMinMax;
        Smed.coefArray(i) = Smed.coefArray(i) * factorMed;
        Smax.coefArray(i) = Smax.coefArray(i) * factorMinMax;
    end
    
    modDecompositionVector = decompositionVector;
    for i=1:SUBBAND_LENGTH
        modDecompositionVector(S(1).posArray(i)) = S(1).coefArray(i);
        modDecompositionVector(S(2).posArray(i)) = S(2).coefArray(i);
        modDecompositionVector(S(3).posArray(i)) = S(3).coefArray(i);
    end
    
%     audiowrite('tmp/orig_dwt.wav',decompositionVector,48000);
%     audiowrite('tmp/mod_dwt.wav',modDecompositionVector,48000);
%     
%     odg = PQevalAudio('tmp/orig_dwt.wav','tmp/mod_dwt.wav')
    
    %diff_C = C - mod_C;
    %plot(diff_C(1:3*SUBBAND_LENGTH));
    
    modSignalSegment = waverec(modDecompositionVector, bookkeepingVector, DWT_WAVELET);
else
    modSignalSegment = origSignalSegment;
end
    


end

