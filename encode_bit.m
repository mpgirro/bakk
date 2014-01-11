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

[C,L] = wavedec(originalSignalSegment, DWT_LEVELS, DWT_WAVELET);



% create unique class instances, therefore don't use repmat(Subband(),3,1)
for i=1:SUBBAND_COUNT
    S(i) = Subband();
end

S(1).i = [1 : SUBBAND_LENGTH];
S(2).i = [SUBBAND_LENGTH+1 : 2*SUBBAND_LENGTH];
S(3).i = [2*SUBBAND_LENGTH : 3*SUBBAND_LENGTH];

for i=1:SUBBAND_COUNT
    % copy corresponding coefficients
    S(i).c = C(S(i).i);
    
    % we only sum up the absolute values, so apply abs() to every element
    S(i).c = arrayfun(@abs,S(i).c);
    
    % calculate the energy level
    S(i).E = sum(S(i).c);
end

[emap, smap] = drawmaps(S);

Emin = smap('min').E;
Emed = smap('med').E;
Emax = smap('max').E;

% calculate energy difference 
A = Emax - Emed; 
B = Emed - Emin;


% emb_str...embedding strength (S im paper)
%emb_str = (esf * sum( C(1:3*SUBBAND_LENGTH) )) / 3; 
emb_str = 2*Emed/(Emed+Emax) * (Emax-Emin)
esf = 3*emb_str/sum( C(1:3*SUBBAND_LENGTH))


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
    Smin = smap('min');
    Smed = smap('med');
    Smax = smap('max');
    for i=1:SUBBAND_LENGTH
        Smin.c(i) = Smin.c(i) * f_minmax;
        Smed.c(i) = Smed.c(i) * f_med;
        Smax.c(i) = Smax.c(i) * f_minmax;
    end
    
    mod_C = C;
    for i=1:SUBBAND_LENGTH
        mod_C(S(1).i(i)) = S(1).c(i);
        mod_C(S(2).i(i)) = S(2).c(i);
        mod_C(S(3).i(i)) = S(3).c(i);
    end
    
    %diff_C = C - mod_C;
    %plot(diff_C(1:3*SUBBAND_LENGTH));

    modifiedSignalSegment = waverec(mod_C, L, DWT_WAVELET);
else
    
    modifiedSignalSegment = originalSignalSegment;
end

end

