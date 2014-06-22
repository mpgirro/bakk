function [ messageBlock ] = wmkdataextractor( sample_sequence )
% Extract watermark information bits of given samples. the bits are
% supposed to be error correction encoded and will therefore be decoded
% utilizing the ECC function specified by the Settings

frameLength = Setting.frame_length; 
wmkSequenceLen = Setting.wmkdata_block_sequence_length;
codewordBlock = zeros([1,wmkSequenceLen]); % preallocate space

sampleCursor = 1;

for i=1:wmkSequenceLen
    
    window = sampleCursor : sampleCursor+frameLength-1;
    codewordBlock(i) = extractbit(sample_sequence(window), frameLength);
    
    sampleCursor = sampleCursor+frameLength;
  
end

messageBlock = ecc_decode(codewordBlock);

end

