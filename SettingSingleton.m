classdef SettingSingleton < handle
    
    properties(Access=private)
        dwt_wavelet;
        dwt_level;
        subband_length;
        embedding_strength_factor;
        bufferzone_scaling_factor;
        synchronization_code;
        wmk_data_block_sequence_length; % amount of bits encoded in one wmk data block

    end
    
    methods(Access=private)
        function newObj = SettingSingleton()
            % Initialise properties.
            newObj.setDwtWavelet('db1');
            newObj.setDwtLevel(6);
            newObj.setSubbandLength(8);
            newObj.setEmbeddingStrengthFactor(10);
            newObj.setBufferzoneScalingFactor(0);
            %newObj.setSynchronizationCode([1, 0, 1, 0, 1, 0, 1, 1]);
            %newObj.setSynchronizationCode([1, 1, 0, 0, 1, 1, 0, 0]);
            newObj.setSynchronizationCode([1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0]);
            newObj.setWmkDataBlockSequenceLength(8);
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
        
        function bzsf = getBufferzoneScalingFactor(obj)
           bzsf = obj.bufferzone_scaling_factor;
        end
        
        function setBufferzoneScalingFactor(obj, bzsf)
            obj.bufferzone_scaling_factor = bzsf;
        end
        
        function sc = getSynchronizationCode(obj)
            sc = obj.synchronization_code;
        end
        
        function setSynchronizationCode(obj, sc)
            obj.synchronization_code = sc;
        end
        
        function wsl = getWmkDataBlockSequenceLength(obj)
            wsl = obj.wmk_data_block_sequence_length;
        end
        
        function setWmkDataBlockSequenceLength(obj, wsl)
            obj.wmk_data_block_sequence_length = wsl;
        end
    
        

    end
    
end

