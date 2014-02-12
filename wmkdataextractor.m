function [ wmkData ] = wmkdataextractor( sample_sequence )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

windowWidth = Setting.coefficient_segment_length;
wmkSequenceLen = Setting.wmk_sequence_length;
wmkData = zeros([1,wmkSequenceLen]); % preallocate space

sampleCursor = 1;

for i=1:wmkSequenceLen
    
    window = sampleCursor : sampleCursor+windowWidth-1;
    wmkData(i) = extractbit(sample_sequence(window));
    
    sampleCursor = sampleCursor+windowWidth;
  
end

end

