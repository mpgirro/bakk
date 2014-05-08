classdef SettingSingleton < handle
    
    properties(Access=private)
        dwt_wavelet;
        dwt_level;
        subband_length;
        embedding_strength_factor;
        bufferzone_scaling_factor;
        synchronization_code;
        barker_threshold;
        bhc_factor;
        message_length;
        codeword_length; 
        error_correction_methode; % BCH, RS, local redundancy, LDPC
        % this is a list of available error correction methods
        ecm_available = {'BCH' 'RS' 'LR' 'LDPC' 'none'}; 
    end
    
    methods(Access=private)
        function newObj = SettingSingleton()
            % Initialise properties.
            newObj.setDwtWavelet('db1');
            newObj.setDwtLevel(6);
            newObj.setSubbandLength(8);
            newObj.setEmbeddingStrengthFactor(10);
            newObj.setBufferzoneScalingFactor(0.1);
            newObj.setSynchronizationCode(13); % barker code 13
            newObj.setBarkerThreshold(0.8);
            newObj.setErrorCorrectionMethode('BCH');
            newObj.setMessageLength(5);     
            newObj.setCodewordLength(15);
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
        
        % amount of bits encoded in one wmk data block
        function wsl = getWmkDataBlockSequenceLength(obj)
            wsl = obj.getCodewordLength;
        end
        
        % amount of bits that will be error correction encoded 
        % into one block
        function ml = getMessageLength(obj)
            ml = obj.message_length;
        end
        
        function setMessageLength(obj, ml)
            obj.message_length = ml;
        end
        
        % length of the bit block that result from error correction
        % encoding when coding message_length bits
        function cwl = getCodewordLength(obj)
            cwl = obj.codeword_length;
        end
        
        function setCodewordLength(obj, cwl)
            obj.codeword_length = cwl;
        end
        
        function ecm = getErrorCorrectionMethode(obj)
            ecm = obj.error_correction_methode;
        end
        
        function setErrorCorrectionMethode(obj,ecm)
            % check if ecm is a supported error correction methode
            if any(ismember(obj.ecm_available,ecm))
                obj.error_correction_methode = ecm;
            else
                fprintf('WARNING: Error Correction Methode "%s" not available\n', ecm);
            end 
        end
        
    end
    
end

