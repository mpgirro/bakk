function [ found ] = synccodedetector( synccodeBlock, frameLength )
% Checks if a sequence of signal samples encode a synchronization code.
% To encode 1 bit, there are frame_length sample values necessary. Each 
% synccode has a length of sync_sequence_length. Therefore the signal sample 
% sequence this function processes musst be: 
%       frame_length x sync_sequence_length 
% values long. 

sampleSize  = size(synccodeBlock);
syncCode    = Setting.sync_code;
codeLength  = Setting.synccode_block_sequence_length;
readCode    = zeros([1,codeLength]);

sampleCursor = 1;

% decode the next X bit
for i=1:codeLength
    
    window = sampleCursor : sampleCursor+frameLength-1;
    
    frame = synccodeBlock(window);
    readCode(i) = extractbit(frame, frameLength);
    
    sampleCursor = sampleCursor+frameLength;
    
end

% well now, check if the decoded bits autocorrelation coefficient satisfy 
% the sync code (barker) threshold 
autocorrelation = barkerautocorrelationcoefficient(readCode);

if autocorrelation > Setting.barker_threshold
    found = 1;
else 
    found = 0;
end

end

