function [ decomposition ] = signaldecomposition( signalSegment )

	[decompositionVector,bookkeepingVector] = wavedec(signalSegment, AlgoSettings.DWT_LEVELS, AlgoSettings.DWT_WAVELET);

	% create unique class instances, therefore don't use repmat(Subband(),3,1)
	for i=1:AlgoSettings.SUBBAND_COUNT
	    S(i) = Subband();
	end

	S(1).posArray = [ 1 : AlgoSettings.SUBBAND_LENGTH ];
	S(2).posArray = [ AlgoSettings.SUBBAND_LENGTH+1 : 2*AlgoSettings.SUBBAND_LENGTH ];
	S(3).posArray = [ 2*AlgoSettings.SUBBAND_LENGTH+1 : 3*AlgoSettings.SUBBAND_LENGTH ];

	for i=1:AlgoSettings.SUBBAND_COUNT
	    % copy corresponding coefficients
	    S(i).coefArray = decompositionVector(S(i).posArray(:));

	    % we only sum up the absolute values, so apply abs() to every element
	    %S(i).coefArray = arrayfun(@abs,S(i).coefArray);

	    % calculate the energy level
	     S(i).energy = sum(abs(S(i).coefArray(:)));
	end

	[energyMap, subbandMap] = drawmaps(S);

	Emin = strMap('min').energy;
	Emed = strMap('med').energy;
	Emax = strMap('max').energy;
	
	A = Emax - Emed; 
	B = Emed - Emin;
	
	% TODO: wir werden alle werte in eine structur spucken
	decomposition = struct('Signal',signalSegment, 'DecompositionVector', decompositionVector, 'BookkeepingVector', bookkeepingVector, 'Subbands', S, 'Emin', Emin, 'Emed', Emed, 'Emax', Emax, 'A', A, 'B', B, 'SubbandMap', subbandMap);

end


