function [watermark] = decoder( signal )

signalSize      = size(signal);
segmentWidth    = Setting.frame_length; % # samples needed to encode 1 bit
segmentCount    = floor(size(signal)/segmentWidth);  % theoretical max amount of segments fitting in this signal, assuming the payload is encoded at sample nr 1
syncSequenceLen = Setting.sync_sequence_length; % amount of bits in one synccode
wmkSequenceLen  = Setting.wmk_block_sequence_length;  % amount of bits in one wmk sequence
syncSegmentLen  = syncSequenceLen * segmentWidth; % amount of samples needed to encode one synccode
wmkSegmentLen   = wmkSequenceLen * segmentWidth;  % amount of samples needed to encode one wmk data block
maxWmkSeqCount  = floor(segmentCount / (syncSequenceLen + wmkSequenceLen)); % there is always a sync sequence and a wmk sequence encoded together
maxWmkBitcount  = maxWmkSeqCount * wmkSequenceLen;
wmkBuffer       = zeros([1, maxWmkBitcount(1)]); % preallocate wmk buffer space for speed

dataStructSegmentLen = syncSegmentLen + wmkSegmentLen;
dataStructCapacity = floor(signalSize(1)/dataStructSegmentLen);

wmkBufferCursor = 1;
sampleCursor = 1;
dataStructCount = 0;

% Calculate the last sample it makes sense to start searching in. After
% this point, the signal is not able to hold and entire sync code +
% corresponting watermark sequence. Therefore, the following bit are random
lastSampleToStartSearching = signalSize(1)-(syncSegmentLen + wmkSegmentLen);

fprintf('Watermark data:\n');

%for i=1:lastSampleToStartSearching
while sampleCursor <= lastSampleToStartSearching
    
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
        
        fmt=[repmat('%d ',1,wmkSequenceLen) '\n'];
        fprintf(fmt,wmkData');
       
        
        % move sample cursor to the end of the window
        sampleCursor = sampleCursor + wmkSegmentLen;
        
        dataStructCount = dataStructCount+1;
    else
        % BAD! shift sample cursor one element and try again
        sampleCursor = sampleCursor+1;
    end
    
    % check if there is still space left in the signal to encode more 
    % (sync, wmk)-data-structures
    if sampleCursor + dataStructSegmentLen > signalSize(1)
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

fprintf('Decoding complete\n');
fprintf('%d bit total payload\n',dataStructCount*syncSequenceLen + dataStructCount*wmkSequenceLen);
fprintf('%d data struct packages\n',dataStructCount);
fprintf('%d watermark data bits\n',wmkBufferCursor-1);

end


