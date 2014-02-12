function [watermark] = decoder( signal )

signalSize      = size(signal);
segmentWidth    = Setting.coefficient_segment_length; % # samples needed to encode 1 bit
segmentCount    = floor(size(signal)/segmentWidth);  % theoretical max amount of segments fitting in this signal, assuming the payload is encoded at sample nr 1
syncSequenceLen = Setting.sync_sequence_length; % amount of bits in one synccode
wmkSequenceLen  = Setting.wmk_sequence_length;  % amount of bits in one wmk sequence
syncSegmentLen  = syncSequenceLen * segmentWidth; % amount of samples needed to encode one synccode
wmkSegmentLen   = wmkSequenceLen * segmentWidth;  % amount of samples needed to encode one wmk data block
maxWmkSeqCount  = floor(segmentCount / (syncSequenceLen + wmkSequenceLen)); % there is always a sync sequence and a wmk sequence encoded together
maxWmkBitcount  = maxWmkSeqCount * wmkSequenceLen;
wmkBuffer       = zeros([1, maxWmkBitcount(1)]); % preallocate wmk buffer space for speed

dataStructSegmentLen = syncSegmentLen + wmkSegmentLen;
dataStructInsertionCapacity = floor(signalSize(1)/dataStructSegmentLen);

wmkBufferCursor = 1;
sampleCursor = 1;

% Calculate the last sample it makes sense to start searching in. After
% this point, the signal is not able to hold and entire sync code +
% corresponting watermark sequence. Therefore, the following bit are random
lastSampleToStartSearching = signalSize(1)-(syncSegmentLen + wmkSegmentLen);

for i=1:lastSampleToStartSearching
    
    syncCodeWindow = sampleCursor : sampleCursor+syncSegmentLen-1;% -1 due to the nature of matlab sequence notation
    
    syncCodeFound = synccodedetector(signal(syncCodeWindow));
    
    if syncCodeFound
        % GOOD! this means the next X samples will hold watermark data
        
        % move sample cursor behind the end of the synccode window
        sampleCursor = sampleCursor + syncSegmentLen;
        
        wmkDataWindow = sampleCursor : sampleCursor+wmkSegmentLen-1;
        wmkData = wmkdataextractor(signal(wmkDataWindow));
        
        wmkBuffer(wmkBufferCursor : wmkBufferCursor+wmkSequenceLen-1) = wmkData;
        wmkBufferCursor = wmkBufferCursor+wmkSequenceLen;
        
        % move sample cursor to the end of the window
        sampleCursor = sampleCursor + wmkSegmentLen;
    else
        % BAD! shift sample cursor one element and try again
        sampleCursor = sampleCursor+1;
    end
    
    % check if there is still space left in the signal to encode more 
    % (sync, wmk)-data-structures
    if sampleCursor + syncSegmentLen + wmkSegmentLen > signalSize(1)
        break;
    end
    
    
end

if wmkBufferCursor == 1
    % oh boy, we did not find any sync codes and
    % therefore have no watermark data
    watermark = [];
else
    % we preallocated space for the theoratically maximum of watermark data
    % bit. but in general we will not have found as many bit. so return
    % only the valid data
    watermark = wmkBuffer(1:wmkBufferCursor-1);
end

end


