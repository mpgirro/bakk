classdef Setting
	
	properties(Constant = true)
        SUBBAND_COUNT = 3; 
    end
    
    properties(Access = private,Constant = true)
        dwt_wavelet = 'db1';
		dwt_level = '6';
        subband_length = 8;
		embedding_strength_factor = 10;
    end
	
	methods(Static = true)
	
		function [output_arg] = getDwtWavelet()
			output_arg = Setting.dwt_wavelet;
		end
		
		function setDwtWavelet(input_arg)
			Setting.dwt_wavelet = input_arg;
		end
		
		function [output_arg] = getDwtLevel()
			output_arg = Setting.dwt_level;
		end
		
		function setDwtLevel(input_arg)
			Setting.dwt_level = input_arg;
		end
		
		function [output_arg] = getSubbandLength()
			output_arg = Setting.subband_length;
		end
		
		function setSubbandLength(input_arg)
			Setting.subband_length = input_arg;
		end
		
		function [output_arg] = getEmbeddingStrengthFactor()
			output_arg = Setting.embedding_strength_factor;
		end
		
		function setEmbeddingStrengthFactor(input_arg)
			Setting.embedding_strength_factor = input_arg;
		end
		
		% Signal Sample Segment Length needed to encode 1 bit
		function [output_arg] = getCoefficientSegmentLength()
			output_arg = (3*Setting.subband_length * 2 ^ Setting.dwt_level);
		end
	
	end
end

