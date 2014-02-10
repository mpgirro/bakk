classdef Setting
    
    properties(Constant = true)
        SUBBAND_COUNT = 3;
    end
    
    methods(Static = true)
        
        function [wavelet] = dwt_wavelet()
            sObj = SettingSingleton.instance();
            wavelet = sObj.getDwtWavelet;
        end
        
        function [level] = dwt_level()
            sObj = SettingSingleton.instance();
            level = sObj.getDwtLevel;
        end
        
        function [length] = subband_length()
            sObj = SettingSingleton.instance();
            length = sObj.getSubbandLength;
        end
        
        
        function [esf] = embedding_strength_factor()
            sObj = SettingSingleton.instance();
            esf = sObj.getEmbeddingStrengthFactor;
        end
        
        
        % Signal Sample Segment Length needed to encode 1 bit
        function [length] = coefficient_segment_length()
            sObj = SettingSingleton.instance();
            length = sObj.getCoefficientSegmentLength;
        end
        
    end
end

