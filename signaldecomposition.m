function [ decomposition ] = signaldecomposition( signalSegment )

    [decompositionVector,bookkeepingVector] = wavedec(signalSegment, Setting.dwt_level, Setting.dwt_wavelet);

    % create unique class instances, therefore don't use repmat(Subband(),3,1)
    for i=1:Setting.SUBBAND_COUNT
        S(i) = Subband();
    end
    
    S(1).posArray = [ 1 : Setting.subband_length ];
    S(2).posArray = [ Setting.subband_length+1 : 2*Setting.subband_length ];
    S(3).posArray = [ 2*Setting.subband_length+1 : 3*Setting.subband_length ];
    
    for i=1:Setting.SUBBAND_COUNT
        % copy corresponding coefficients
        S(i).coefArray = decompositionVector(S(i).posArray(:));
        
        % we only sum up the absolute values, so apply abs() to every element
        %S(i).coefArray = arrayfun(@abs,S(i).coefArray);
        
        % calculate the energy level
        S(i).energy = sum(abs(S(i).coefArray(:)));
    end
    
    [~, subbandMap] = drawmaps(S);
    
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
                            'Subbands', S, ...
                            'Emin', Emin, ...
                            'Emed', Emed, ...
                            'Emax', Emax, ...
                            'A', A, ...
                            'B', B, ...
                            'SubbandMap', subbandMap);

end

