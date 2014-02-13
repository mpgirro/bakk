function [ decomposition ] = signaldecomposition( signalSegment )

[decompositionVector,bookkeepingVector] = wavedec(signalSegment, Setting.dwt_level, Setting.dwt_wavelet);

% create unique class instances, therefore don't use repmat(Subband(),3,1)
for i=1:Setting.SUBBAND_COUNT
    subbands(i) = Subband();
end

bandWidth = Setting.subband_length;

subbands(1).posArray = [ 1 : bandWidth ];
subbands(2).posArray = [ bandWidth+1 : 2*bandWidth ];
subbands(3).posArray = [ 2*bandWidth+1 : 3*bandWidth ];

for i=1:Setting.SUBBAND_COUNT
    % copy corresponding coefficients
    subbands(i).coefArray = decompositionVector(subbands(i).posArray(:));
    
    % calculate the energy level
    subbands(i).energy = sum(abs(subbands(i).coefArray(:)));
end


%   emap...Energy -> classpointer
%   smap...String -> classpointer
energyMap = containers.Map('KeyType','double','ValueType','any');
subbandMap = containers.Map('KeyType','char','ValueType','any');


for i=1:3
    energyMap(subbands(i).energy) = subbands(i);
end

unsorted_E = [subbands(:).energy];
sorted_E = sort(unsorted_E);

subbandMap('min') = energyMap(sorted_E(1));
subbandMap('med') = energyMap(sorted_E(2));
subbandMap('max') = energyMap(sorted_E(3));


Emin = subbandMap('min').energy;
Emed = subbandMap('med').energy;
Emax = subbandMap('max').energy;

% calculate energy difference
A = Emax - Emed;
B = Emed - Emin;

% TODO: wir werden alle werte in eine structur spucken
decomposition = struct( 'Signal', signalSegment, ...
    'DecompositionVector', decompositionVector, ...
    'BookkeepingVector', bookkeepingVector, ...
    'Subbands', subbands, ...
    'Emin', Emin, ...
    'Emed', Emed, ...
    'Emax', Emax, ...
    'A', A, ...
    'B', B, ...
    'SubbandMap', subbandMap);

end


