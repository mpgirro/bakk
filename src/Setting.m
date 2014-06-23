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
        
        
        % sync code = base sync code with local redundancy applied
        function code = sync_code()
            sObj = SettingSingleton.instance();
            code = sObj.getSynchronizationCode;
        end
        
        function threshold = barker_threshold()
            sObj = SettingSingleton.instance();
            threshold = sObj.getBarkerThreshold;
        end
        
        
        function length = frame_data_samples_length()
            sObj = SettingSingleton.instance();
            length = 3* sObj.getSubbandLength * 2 ^ sObj.getDwtLevel;
        end
        
        function length = frame_buffer_samples_length()
            sObj = SettingSingleton.instance();
            length = floor(Setting.frame_data_samples_length * sObj.getBufferzoneScalingFactor);
        end
        
        % amount of samples needed to encode 1 bit
        function [length] = frame_length()
            length = Setting.frame_data_samples_length + Setting.frame_buffer_samples_length;
        end
        
        function length = synccode_block_sequence_length()
            codeSize = size(Setting.sync_code);
            length = codeSize(2);
        end
        
        function length = wmkdata_block_sequence_length()
            sObj = SettingSingleton.instance();
            length = sObj.getWmkDataBlockSequenceLength;
        end
        
        function length = message_length()
            sObj = SettingSingleton.instance();
            length = sObj.getMessageLength();
        end
        
        function length = codeword_length()
            sObj = SettingSingleton.instance();
            length = sObj.getCodewordLength();
        end
        
        function ecm = error_correcion_methode()
           sObj = SettingSingleton.instance();
           ecm = sObj.getErrorCorrectionMethode();
        end
        
        function length = datastruct_package_sequence_length()
            length = Setting.synccode_block_sequence_length + Setting.wmkdata_block_sequence_length;
        end
        
        function length = synccode_block_sample_length()
            length = Setting.frame_length * Setting.synccode_block_sequence_length;
        end
        
        function length = wmkdata_block_sample_length()
            length = Setting.frame_length * Setting.wmkdata_block_sequence_length;
        end
        
        function length = datastruct_package_sample_length()
            length = Setting.synccode_block_sample_length + Setting.wmkdata_block_sample_length;
        end
        
        function odg_bool = consider_odg()
            sObj = SettingSingleton.instance();
            odg_bool = sObj.getConsiderODG();
        end
        
    end
end

