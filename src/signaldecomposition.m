function [ decomposition ] = signaldecomposition( signalSegment )
% This function decomposes given signal segment into the parts needed for
% watermark encoding and decoding. all information will be returned as a
% struct field
%
% Copyright (C) 2013-2014, Maximilian Irro <max@disposia.org>
%

% perform the DWT 
[decompositionVector,bookkeepingVector] = wavedec(signalSegment, Setting.dwt_level, Setting.dwt_wavelet);

% create unique class instances, therefore don't use repmat(Subband(),3,1)
for i=1:Setting.SUBBAND_COUNT
    subbands(i) = Subband();
end

bandWidth = Setting.subband_length;

% associate every subband with the corresponding coefficient indizes
subbands(1).posArray = 1 : bandWidth;
subbands(2).posArray = bandWidth+1 : 2*bandWidth;
subbands(3).posArray = 2*bandWidth+1 : 3*bandWidth;

% copy coefficient values and calculate abs energy band sum
for i=1:Setting.SUBBAND_COUNT
    % copy corresponding coefficients
    subbands(i).coefArray = decompositionVector(subbands(i).posArray(:));
    
    % calculate the energy level
    subbands(i).energy = sum(abs(subbands(i).coefArray(:)));
end

% create a map to easily reference the min|med|max energy subbands
%   emap...Energy -> classpointer
%   smap...String -> classpointer
energyMap = containers.Map('KeyType','double','ValueType','any');
subbandMap = containers.Map('KeyType','char','ValueType','any');

for i=1:Setting.SUBBAND_COUNT
    energyMap(subbands(i).energy) = subbands(i);
end

% sort the energy values
unsorted_E = [subbands(:).energy];
sorted_E = sort(unsorted_E);

% connect subbands with their associated energy value, e.g.
% min -> Subband where E = min
subbandMap('min') = energyMap(sorted_E(1));
subbandMap('med') = energyMap(sorted_E(2));
subbandMap('max') = energyMap(sorted_E(3));

% read the energy values
Emin = subbandMap('min').energy;
Emed = subbandMap('med').energy;
Emax = subbandMap('max').energy;

% calculate energy difference
A = Emax - Emed;
B = Emed - Emin;

% return the calculated values in a struct
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


