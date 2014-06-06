function [ messageBlock ] = wmkdataextractor( sample_sequence )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

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

% messageLength = Setting.message_length;
% codewordLength = Setting.codeword_length;
% fmt=[repmat('%d ',1,codewordLength) '==ecc==> ' repmat('%d ',1,messageLength) '\n'];
% fprintf(fmt,codewordBlock',messageBlock');

end

