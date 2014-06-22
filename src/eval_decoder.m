function [watermark] = eval_decoder( signal )
% WARNING! This is a modified decoder Version, aimed on evaluating signals. 
% This function MUST NOT be used as productive decoder!

% Cpyright (C) 2014 Maximilian Irro

signalSize      = size(signal);
signalSize      = signalSize(1);
frameLength     = Setting.frame_length; % # samples needed to encode 1 bit
segmentCount    = floor(signalSize/frameLength);  % theoretical max amount of segments fitting in this signal, assuming the payload is encoded at sample nr 1
syncSequenceLen = Setting.synccode_block_sequence_length; % amount of bits in one synccode
wmkSequenceLen  = Setting.wmkdata_block_sequence_length;  % amount of bits in one wmk sequence
syncSampleLen   = Setting.synccode_block_sample_length; % amount of samples needed to encode one synccode
wmkSampleLen    = Setting.wmkdata_block_sample_length;  % amount of samples needed to encode one wmk data block
dataStructSampleLen = Setting.datastruct_package_sample_length;
dataStructSequenceLen   = Setting.datastruct_package_sequence_length;
dataStructCapacity = floor(signalSize/dataStructSampleLen);
maxWmkSeqCount  = floor(segmentCount / dataStructSequenceLen ); % there is always a sync sequence and a wmk sequence encoded together
maxWmkBitcount  = maxWmkSeqCount * wmkSequenceLen;
wmkBuffer       = zeros([1, maxWmkBitcount(1)]); % preallocate wmk buffer space for speed

messageLength = Setting.message_length;
codewordLength = Setting.codeword_length;

wmkBufferCursor = 1;
sampleCursor    = 1;
dataStructCount = 0;

packets_lost = 0;
payload_damaged = 0;

% Calculate the last sample it makes sense to start searching in. After
% this point, the signal is not able to hold and entire sync code +
% corresponting watermark sequence. Therefore, the following bit are random
lastSampleToStartSearching = signalSize-dataStructSampleLen;

fprintf('Extracted messages:\n');

%for i=1:lastSampleToStartSearching
while sampleCursor <= lastSampleToStartSearching
    
    syncCodeWindow = sampleCursor : sampleCursor+syncSampleLen-1;% -1 due to the nature of matlab sequence notation
    
    syncCodeFound = synccodedetector(signal(syncCodeWindow), frameLength);
    if ~syncCodeFound
        packets_lost = packets_lost + 1;
    end
    
    % move sample cursor behind the end of the synccode window
    sampleCursor = sampleCursor + syncSampleLen;
    
    wmkDataWindow = sampleCursor : sampleCursor+wmkSampleLen-1;
    wmkData = wmkdataextractor(signal(wmkDataWindow));
    
    wmkBuffer(wmkBufferCursor : wmkBufferCursor+messageLength-1) = wmkData;
    wmkBufferCursor = wmkBufferCursor+messageLength;
    
    fmt=[repmat('%d ',1,messageLength) '--> %d (SOLL %d) \t > %c\n'];
    wmk_dec = bi2de(wmkData','left-msb');
    decode_success = 'X';
    if wmk_dec == dataStructCount
        decode_success = 'O';
    else
        payload_damaged = payload_damaged + 1;
    end
    fprintf(fmt,wmkData', wmk_dec, dataStructCount, decode_success);
    
    
    % move sample cursor to the end of the window
    sampleCursor = sampleCursor + wmkSampleLen;
    
    dataStructCount = dataStructCount+1;
    
    
    if dataStructCount > dataStructCapacity
        break;
    end
    
    %     % check if there is still space left in the signal to encode more
    %     % (sync, wmk)-data-structures
    %     if sampleCursor + dataStructSampleLen > signalSize
    %         break;
    %     end
    
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

fprintf('Packets lost: %d\n',packets_lost);
fprintf('Damaged payloads: %d\n',payload_damaged);

end




