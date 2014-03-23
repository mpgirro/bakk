function [ wmkData ] = wmkdataextractor( sample_sequence )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

frameLength = Setting.frame_length; 
wmkSequenceLen = Setting.wmkdata_block_sequence_length;
wmkData = zeros([1,wmkSequenceLen]); % preallocate space

sampleCursor = 1;

for i=1:wmkSequenceLen
    
    window = sampleCursor : sampleCursor+frameLength-1;
    wmkData(i) = extractbit(sample_sequence(window));
    
    sampleCursor = sampleCursor+frameLength;
  
end

end

