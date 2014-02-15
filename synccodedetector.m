function [ found ] = synccodedetector( synccodeBlock )
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

sampleSize  = size(synccodeBlock);
frameLength = Setting.frame_length;
syncCode    = Setting.sync_code;
codeLength  = Setting.synccode_block_sequence_length;
readCode    = zeros([1,codeLength]);

sampleCursor = 1;

for i=1:codeLength
    
    window = sampleCursor : sampleCursor+frameLength-1;
    
    frame = synccodeBlock(window);
    readCode(i) = extractbit(frame);
    
    sampleCursor = sampleCursor+frameLength;
    
end

found = isequal(syncCode,readCode);

end

