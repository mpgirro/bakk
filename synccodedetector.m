function [ found ] = synccodedetector( sample_sequence )
%SYNCCODEDETECTOR checks if a sequence of signal samples holds a synccode
%   Checks if a sequence of signal samples encode a synchronization code.
%   To encode 1 bit, there are frame_length sample values
%   necessary. Each synccode has a length of sync_sequence_length. Therefore
%   the signal sample sequence this function processes musst be:
%   frame_length x sync_sequence_length values long. 
%
%   sample_sequence...frame_length x sync_sequence_length
%   samples values of the signal
%   found...boolean value, true if valid sync code sequence found, false
%   otherwise

sampleSize  = size(sample_sequence);
windowWidth = Setting.frame_length;
syncCode    = Setting.sync_code;
codeLength  = Setting.synccode_block_sequence_length;
readCode    = zeros([1,codeLength]);

windowStart = 1;
windowEnd   = windowWidth;

for i=1:codeLength
    
    segment = sample_sequence(windowStart:windowEnd);
    readCode(i) = extractbit(segment);
    
    windowStart = windowStart + windowWidth;
    windowEnd   = windowEnd + windowWidth;
    
end

found = isequal(syncCode,readCode);

end

