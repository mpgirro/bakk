function [ modSignalSegment ] = encode_bit( origSignalSegment, bit )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%
%   

[decompositionVector,bookkeepingVector] = wavedec(origSignalSegment, AWA.DWT_LEVELS, AWA.DWT_WAVELET);

% create unique class instances, therefore don't use repmat(Subband(),3,1)
for i=1:AWA.SUBBAND_COUNT
    S(i) = Subband();
end

S(1).posArray = [1 : AWA.SUBBAND_LENGTH];
S(2).posArray = [AWA.SUBBAND_LENGTH+1 : 2*AWA.SUBBAND_LENGTH];
S(3).posArray = [2*AWA.SUBBAND_LENGTH : 3*AWA.SUBBAND_LENGTH];

for i=1:AWA.SUBBAND_COUNT
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
esf = AWA.EMBEDDING_STRENGTH_FACTOR;

    
% emb_str...embedding strength (S im paper)
emb_str = (esf * sum( decompositionVector(1:3*AWA.SUBBAND_LENGTH) )) / 3;

% satisfy equation (8)
if emb_str >= 2*Emed/(Emed+Emax) * (Emax-Emin)
    fprintf('reduceing S from %8f ',emb_str);
    emb_str = 2*Emed/(Emed+Emax) * (Emax-Emin);
    fprintf('to %8f\n',emb_str);
end

% satisfy equation (11)
if emb_str >= 2*Emed/(Emed+Emin) * (Emax-Emin)
    fprintf('reduceing S from %8f ',emb_str);
    emb_str = 2*Emed/(Emed+Emin) * (Emax-Emin);
    fprintf('to %8f\n',emb_str);
end

fprintf('bit=%d\n',bit);
fprintf('A-B=%8f\n',A-B);
fprintf('B-A=%8f\n',B-A);
fprintf('S=%8f\n\n',emb_str);

insertion = false;

if bit == 1 && A-B >= emb_str
    %do nothing - bit '1' can already logically encoded
elseif bit == 0 && B-A >= emb_str
    %do nothing - bit '0' can already logically encoded
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
    for i=1:AWA.SUBBAND_LENGTH
        Smin.coefArray(i) = Smin.coefArray(i) * factorMinMax;
        Smed.coefArray(i) = Smed.coefArray(i) * factorMed;
        Smax.coefArray(i) = Smax.coefArray(i) * factorMinMax;
    end
    
    modDecompositionVector = decompositionVector;
    for i=1:AWA.SUBBAND_LENGTH
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
    
    modSignalSegment = waverec(modDecompositionVector, bookkeepingVector, AWA.DWT_WAVELET);
else
    modSignalSegment = origSignalSegment;
end
    


end

