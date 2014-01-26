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
    %S(i).coefArray = arrayfun(@abs,S(i).coefArray);
    
    % calculate the energy level
     S(i).energy = sum(abs(S(i).coefArray));
end

[energyMap, strMap] = drawmaps(S);

Emin = strMap('min').energy;
Emed = strMap('med').energy;
Emax = strMap('max').energy;

% calculate energy difference 
A = Emax - Emed; 
B = Emed - Emin;


% embedding strength factor
esf = AlgoConst.EMBEDDING_STRENGTH_FACTOR;

% emb_str...embedding strength (S im paper)
emb_str = (esf * sum( abs(decompositionVector(1:3*AlgoConst.SUBBAND_LENGTH)) )) / 3;

% satisfy equation (11)
if emb_str >= 2*Emed/(Emed+Emin) * (Emax-Emin)
%    fprintf('reduceing S from %8f ',emb_str);
    emb_str = 2*Emed/(Emed+Emin) * (Emax-Emin);
%    fprintf('to %8f [satisfying (11)]\n',emb_str);
end

% satisfy equation (8)
if emb_str >= 2*Emed/(Emed+Emax) * (Emax-Emin)
%    fprintf('reduceing S from %8f ',emb_str);
    emb_str = 2*Emed/(Emed+Emax) * (Emax-Emin);
%    fprintf('to %8f [satisfying (8)]\n',emb_str);
end


% THIS IS A SECURITY MARGIN OF MY OWN DESIGN
% emb_str = emb_str - 0.1*emb_str;



% fprintf('PAYLOAD: %g\n',bit);
% fprintf('A-B=%8f\n',A-B);
% fprintf('B-A=%8f\n',B-A);
% fprintf('S=%8f\n',emb_str);

insertion = false;

if bit == 1 && A-B >= emb_str
    %do nothing - bit '1' can already logically encoded
%    fprintf('encoding bit: 1\n');
elseif bit == 0 && B-A >= emb_str
    %do nothing - bit '0' can already logically encoded
%    fprintf('encoding bit: 0\n');
else
    
    % engery level differences do not satisfy the logic yet
    % we need to do some adjustments
    
    if bit == 1 && A-B < emb_str
    
        insertion = true;
        
        %     fprintf('A-B=%d\n',A-B);
        
        % we have to modify the coefficients
        
        xi = abs(emb_str-A+B);
        
        % precalculate the alteration factors to the coefficients
        % these are static and not influenced by the c(i)
        factorMinMax = 1 + xi/(Emax + 2*Emed + Emin);
        factorMed 	 = 1 - xi/(Emax + 2*Emed + Emin);
    
    elseif bit == 0 && B-A < emb_str
    
        insertion = true;
        %     fprintf('B-A=%d\n',B-A);
        
        xi = abs(emb_str+A-B);
        
        % precalculate the alteration factors to the coefficients
        % these are static and not influenced by the c(i)
        factorMinMax = 1 - xi/(Emax + 2*Emed + Emin);
        factorMed 	 = 1 + xi/(Emax + 2*Emed + Emin);
	else
		fprintf('Oh boy, there is something really wrong here\n'); 
    end
end

% - - - debugging - - -
mod_bit = 'X';
% - - - 

if(insertion)
    
%    fprintf('Modifying energy levels\n');
    
    Smin = strMap('min');
    Smed = strMap('med');
    Smax = strMap('max');
	
    for i=1:AlgoConst.SUBBAND_LENGTH
        Smin.coefArray(i) = Smin.coefArray(i) * factorMinMax;
        Smed.coefArray(i) = Smed.coefArray(i) * factorMed;
        Smax.coefArray(i) = Smax.coefArray(i) * factorMinMax;
    end
	
	
	% debugging - - - - - - - - - - - 

	Emin_mod = sum(Smin.coefArray(i));
	Emed_mod = sum(Smed.coefArray(i));
	Emax_mod = sum(Smax.coefArray(i));

	A_mod = Emax_mod - Emed_mod;
	B_mod = Emed_mod - Emin_mod;

	if A_mod > B_mod
		mod_bit = '1';
%		 fprintf('[INSERTION-CHECK] encoded: 1\n');
	 else
		 mod_bit = '0';
%		 fprintf('[INSERTION-CHECK] encoded: 0\n'); 
	 end

	%  - - - - - - - - - - - - - - - - - 
	
    
    modDecompositionVector = decompositionVector;
    for i=1:AlgoConst.SUBBAND_LENGTH
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
    
    modSignalSegment = waverec(modDecompositionVector, bookkeepingVector, AlgoConst.DWT_WAVELET);

%     r = snr(origSignalSegment,modSignalSegment)
%     fprintf('SNR=%8f\n',r);
%     rauschen = abs(origSignalSegment) - abs(modSignalSegment);
%     plot(rauschen);
    
else
%    fprintf('Energy levels already ok - not doing anything\n');
    modSignalSegment = origSignalSegment;
end


% - - - final checks - - - 

extracted_bit = extractbit( modSignalSegment );
fprintf('[CHECK] %g | %c | %g', bit, mod_bit, extracted_bit);
if bit ~= extracted_bit
	fprintf(' [!] Emin=%4f, Emed=%4f, Emax=%4f, Emin_mod=%4f, Emed_mod=%4f, Emax_mod=%4f', Emin, Emed, Emax, Emin_mod, Emed_mod, Emax_mod );
end
fprintf('\n');

% - - - - - - - - - - - -


end

