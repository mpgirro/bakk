function [ modified_signal_segment ] = encode_bit( original_signal_segment, bit )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%
%   

DWT_WAVELET = 'db2';
DWT_LEVELS = 6;
SUBBAND_LENGTH = 8;
SUBBAND_COUNT = 3;

[C,L] = wavedec(original_signal_segment, DWT_LEVELS, DWT_WAVELET);



% create unique class instances, therefore don't use repmat(Subband(),3,1)
for i=1:SUBBAND_COUNT
    subbands = Subband();
end

subbands(1).i = [1 : SUBBAND_LENGTH];
subbands(2).i = [SUBBAND_LENGTH+1 : 2*SUBBAND_LENGTH];
subbands(3).i = [2*SUBBAND_LENGTH : 3*SUBBAND_LENGTH];

for i=1:SUBBAND_COUNT
    % copy corresponding coefficients
    subbands(i).c = C(subbands(i).i);
    
    % we only sum up the absolute values, so apply abs() to every element
    subbands(i).c = arrayfun(@abs,subbands(i).c);
    
    % calculate the energy level
    subbands(i).E = sum(subbands(i).c);
end

[emap, smap] = drawmaps(subband);

Emin = smap('min');
Emed = smap('med');
Emax = smap('max');

% calculate energy difference 
A = Emax - Emed; 
B = Emed - Emin;

% S...embedding strength
S = (d * sum( C(1:3*Lb) )) / 3; 

if bit == 1 && A-B < S
    
    % we have to modify the coefficients
    
    xi = abs(S-A+B);
    
    % precalculate the alteration factors to the coefficients
    % these are static and not influenced by the c(i)
    f_minmax = 1 + xi/(Emax + 2*Emed + Emin);
    f_med = 1 - xi/(Emax + 2*Emed + Emin);
    
    Smin = smap('min');
    Smed = smap('med');
    Smax = smap('max');
    for i=1:SUBBAND_LENGTH
        Smin.d(i) = Smin.c(i) * f_minmax;
        Smed.d(i) = Smed.c(i) * f_med;
        Smax.d(i) = Smax.c(i) * f_minmax;
    end
    

elseif bit == 0 && B - A <= S 
    
    xi = abs(S+A-B);
    
    % precalculate the alteration factors to the coefficients
    % these are static and not influenced by the c(i)
    f_minmax = 1 - xi/(Emax + 2*Emed + Emin);
    f_med = 1 + xi/(Emax + 2*Emed + Emin);
    
    Smin = smap('min');
    Smed = smap('med');
    Smax = smap('max');
    for i=1:SUBBAND_LENGTH
        Smin.d(i) = Smin.c(i) * f_minmax;
        Smed.d(i) = Smed.c(i) * f_med;
        Smax.d(i) = Smax.c(i) * f_minmax;
    end
    
else
    % we do absoluteley nothing
end


% nun schreiben wir die neuen koeffizienten ins signal zur?ck
mod_C = C;
for i=1:SUBBAND_LENGTH
   mod_C(subbands(1).i(i)) = subbands(1).d(i);
   mod_C(subbands(2).i(i)) = subbands(2).d(i);
   mod_C(subbands(3).i(i)) = subbands(3).d(i);
end

modified_signal_segment = waverec(mod_C, L, DWT_WAVELET);

end

