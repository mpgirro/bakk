path = ['..',filesep,'Audio',filesep,'Test Snippets',filesep,'flute.wav'];
[signal,fs] = wavread(path);


WAVELET_BASE_FUNCTION = 'db2';

%plot( [1:96375], signal)

[C,L] = wavedec(signal,6,'db2');

SUBBAND_LENGTH = 8;
SUBBAND_COUNT = 3;

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

if wmk(insertfancyvariablenamehere) == 1 && A-B < S
    
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
    
    % TODO for all C(i) in Emed
    
    
%     % TODO it should hold that S <= 2*Emed/(Emed+Emax)*(Emax-Emin)
%     
%     xi = S-A+B;
%     
%     Emax_tick = E_max * (1 + xi / (Emax + 2*Emed + Emin));
%     Emed_tick = E_med * (1 - xi / (Emax + 2*Emed + Emin));
%     Emin_tick = E_min * (1 + xi / (Emax + 2*Emed + Emin));

elseif wmk(insertfancyvariablenamehere) == 0 && B - A <= S 
    
    xi = abs(S+A-B);
    
    % precalculate the alteration factors to the coefficients
    % these are static and not influenced by the c(i)
    f_minmax = 1 - xi/(Emax + 2*Emed + Emin);
    f_med = 1 + xi/(Emax + 2*Emed + Emin);
    
    for i=1:SUBBAND_LENGTH
        Smin.d(i) = Smin.c(i) * f_minmax;
        Smed.d(i) = Smed.c(i) * f_med;
        Smax.d(i) = Smax.c(i) * f_minmax;
    end
    
%     % TODO it should hold that S <= 2*Emed/(Emed+Emin)*(Emax-Emin)
%     
%     xi = S+A-B;
%     
%     Emax_tick = E_max * (1 - xi / (Emax + 2*Emed + Emin));
%     Emed_tick = E_med * (1 + xi / (Emax + 2*Emed + Emin));
%     Emin_tick = E_min * (1 - xi / (Emax + 2*Emed + Emin));
else
    % we do absoluteley nothing
end
    
   


