classdef SettingSingleton < handle
    
    properties(Access=private)
        dwt_wavelet;
        dwt_level;
        subband_length;
        embedding_strength_factor;
        base_synchronization_code;
        watermark_sequence_length;
        synccode_redundancy_rate;
    end
    
    methods(Access=private)
        function newObj = SettingSingleton()
            % Initialise properties.
            newObj.setDwtWavelet('db1');
            newObj.setDwtLevel(6);
            newObj.setSubbandLength(8);
            newObj.setEmbeddingStrengthFactor(10);
            newObj.setBaseSynchronizationCode([1, 0, 1, 0, 1, 0, 1, 1]);
            %newObj.setSynchronizationCode([1, 1, 0, 0, 1, 1, 0, 0]);
            newObj.setWmkSequenceLength(8);
            newObj.setSyncCodeRedundancyRate(3);
        end
    end
    
    methods(Static)
        
        function obj = instance()
            persistent uniqueInstance
            if isempty(uniqueInstance)
                obj = SettingSingleton();
                uniqueInstance = obj;
            else
                obj = uniqueInstance;
            end
        end
        
    end
    
    methods % Public Access
        
        function wavelet = getDwtWavelet(obj)
            wavelet = obj.dwt_wavelet;
        end
        
        function setDwtWavelet(obj, wavelet)
            obj.dwt_wavelet = wavelet;
        end
        
        function level = getDwtLevel(obj)
            level = obj.dwt_level;
        end
        
        function setDwtLevel(obj, level)
            obj.dwt_level = level;
        end
        
        function length = getSubbandLength(obj)
            length = obj.subband_length;
        end
        
        function setSubbandLength(obj, length)
            obj.subband_length = length;
        end
        
        function esf = getEmbeddingStrengthFactor(obj)
            esf = obj.embedding_strength_factor;
        end % getEmbeddingStrengthFactor method
        
        function setEmbeddingStrengthFactor(obj, esf)
            obj.embedding_strength_factor = esf;
        end
        
        function sc = getBaseSynchronizationCode(obj)
            sc = obj.base_synchronization_code;
        end
        
        function setBaseSynchronizationCode(obj, sc)
            obj.base_synchronization_code = sc;
        end
        
        function wsl = getWmkSequenceLength(obj)
            wsl = obj.watermark_sequence_length;
        end
        
        function setWmkSequenceLength(obj, wsl)
            obj.watermark_sequence_length = wsl;
        end
        
        function rr = getSyncCodeRedundancyRate(obj)
            rr = obj.synccode_redundancy_rate;
        end
        
        function setSyncCodeRedundancyRate(obj, rr)
            obj.synccode_redundancy_rate = rr;
        end
        

    end
    
end

