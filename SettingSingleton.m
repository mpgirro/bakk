classdef SettingSingleton < handle
    
    properties(Access=private)
        dwt_wavelet;
        dwt_level;
        subband_length;
        embedding_strength_factor;
        bufferzone_scaling_factor;
        synchronization_code;
        barker_threshold;
        wmk_data_block_sequence_length; % amount of bits encoded in one wmk data block

    end
    
    methods(Access=private)
        function newObj = SettingSingleton()
            % Initialise properties.
            newObj.setDwtWavelet('db1');
            newObj.setDwtLevel(6);
            newObj.setSubbandLength(8);
            newObj.setEmbeddingStrengthFactor(1);
            newObj.setBufferzoneScalingFactor(0);
            %newObj.setSynchronizationCode([1, 0, 1, 0, 1, 0, 1, 1]);
            %newObj.setSynchronizationCode([1, 1, 0, 0, 1, 1, 0, 0]);
            newObj.setSynchronizationCode(13); % barker code 13
            newObj.setBarkerThreshold(0.8);
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
        
        % input argument must be member of [1, 2, 3, 4, 5, 7, 11, 13]
        % (valid barker code
        function setSynchronizationCode(obj, sc)
            
            % check if argument valid, set to maximum else
            if any([1, 2, 3, 4, 5, 7, 11, 13] == sc) == 0
                sc = 13;
            end
            
            hBCode = comm.BarkerCode('Length',sc,'SamplesPerFrame',sc,'OutputDataType', 'int8');
            seq = step(hBCode);
            seq(seq==-1) = 0;
            obj.synchronization_code = seq';
        end
        
        function bt = getBarkerThreshold(obj)
            bt = obj.barker_threshold;
        end
        
        function setBarkerThreshold(obj, bt)
            obj.barker_threshold = bt;
        end
        
        function wsl = getWmkDataBlockSequenceLength(obj)
            wsl = obj.wmk_data_block_sequence_length;
        end
        
        function setWmkDataBlockSequenceLength(obj, wsl)
            obj.wmk_data_block_sequence_length = wsl;
        end
    
        

    end
    
end

