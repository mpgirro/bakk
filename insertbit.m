function [ modSignalSegment ] = insertbit( origSignalSegment, bit )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%
%   

[decompositionVector,bookkeepingVector] = wavedec(origSignalSegment, AlgoConst.DWT_LEVELS, AlgoConst.DWT_WAVELET);

% create unique class instances, therefore don't use repmat(Subband(),3,1)
for i=1:AlgoConst.SUBBAND_COUNT
    S(i) = Subband();
end

S(1).posArray = [1 : AlgoConst.SUBBAND_LENGTH];
S(2).posArray = [AlgoConst.SUBBAND_LENGTH+1 : 2*AlgoConst.SUBBAND_LENGTH];
S(3).posArray = [2*AlgoConst.SUBBAND_LENGTH+1 : 3*AlgoConst.SUBBAND_LENGTH];

for i=1:AlgoConst.SUBBAND_COUNT
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
esf = AlgoConst.EMBEDDING_STRENGTH_FACTOR;

    
% emb_str...embedding strength (S im paper)
emb_str = (esf * sum( decompositionVector(1:3*AlgoConst.SUBBAND_LENGTH) )) / 3;

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
fprintf('S=%8f\n',emb_str);

insertion = false;

if bit == 1 && A-B >= emb_str
    %do nothing - bit '1' can already logically encoded
    fprintf('encoding bit: 1\n');
elseif bit == 0 && B-A >= emb_str
    %do nothing - bit '0' can already logically encoded
    fprintf('encoding bit: 0\n');
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
    
    fprintf('Modifying energy levels\n');
    
    Smin = strMap('min');
    Smed = strMap('med');
    Smax = strMap('max');
    for i=1:AlgoConst.SUBBAND_LENGTH
        Smin.coefArray(i) = Smin.coefArray(i) * factorMinMax;
        Smed.coefArray(i) = Smed.coefArray(i) * factorMed;
        Smax.coefArray(i) = Smax.coefArray(i) * factorMinMax;
    end
    
    modDecompositionVector = decompositionVector;
    for i=1:AlgoConst.SUBBAND_LENGTH
        modDecompositionVector(S(1).posArray(i)) = S(1).coefArray(i);
        modDecompositionVector(S(2).posArray(i)) = S(2).coefArray(i);
        modDecompositionVector(S(3).posArray(i)) = S(3).coefArray(i);
    end
    
    % debugging - - - - - - - - - - - 
    
    %Emax modified should be
    Emax_mod_sb = sum(strMap('max').coefArray);
    
    %Emed modified should be
    Emed_mod_sb = sum(strMap('med').coefArray);
    
    %Emin modified should be
    Emin_mod_sb = sum(strMap('min').coefArray);
            
    if bit == 1
        Emax_mod_is = Emax * (1 + xi/(Emax+2*Emed +Emin));
        Emed_mod_is = Emed * (1 - xi/(Emax+2*Emed +Emin));
        Emin_mod_is = Emin * (1 + xi/(Emax+2*Emed +Emin));
        fprintf('encoding bit: 1\n');
    else
        Emax_mod_is = Emax * (1 - xi/(Emax+2*Emed +Emin));
        Emed_mod_is = Emed * (1 + xi/(Emax+2*Emed +Emin));
        Emin_mod_is = Emin * (1 - xi/(Emax+2*Emed +Emin));
        fprintf('encoding bit: 0\n');
    end
    
    fprintf('E?max=%8f (IST) | E?max=%8f (SB) | IST-SB=%8f (DIFF)\n',Emax_mod_is, Emax_mod_sb, Emax_mod_is-Emax_mod_sb);
    fprintf('E?med=%8f (IST) | E?med=%8f (SB) | IST-SB=%8f (DIFF)\n',Emed_mod_is, Emed_mod_sb, Emed_mod_is-Emed_mod_sb);
    fprintf('E?min=%8f (IST) | E?min=%8f (SB) | IST-SB=%8f (DIFF)\n',Emin_mod_is, Emin_mod_sb, Emin_mod_is-Emin_mod_sb);
    %  - - - - - - - - - - - - - - - - - 
    
%     audiowrite('tmp/orig_dwt.wav',decompositionVector,48000);
%     audiowrite('tmp/mod_dwt.wav',modDecompositionVector,48000);
%     
%     odg = PQevalAudio('tmp/orig_dwt.wav','tmp/mod_dwt.wav')
    
    %diff_C = C - mod_C;
    %plot(diff_C(1:3*SUBBAND_LENGTH));
    
    modSignalSegment = waverec(modDecompositionVector, bookkeepingVector, AlgoConst.DWT_WAVELET);

%     r = snr(origSignalSegment,modSignalSegment)
%     fprintf('SNR=%8f\n',r);
%     rauschen = abs(origSignalSegment) - abs(modSignalSegment);
%     plot(rauschen);
    
else
    fprintf('Energy levels already ok - not doing anything\n');
    modSignalSegment = origSignalSegment;
end

end

