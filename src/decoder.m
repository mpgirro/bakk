function [watermark] = decoder( signal, fs )
% Decode a signal by searching for sync codes, extract the message from
% each package and linkung the message parts. 

signalSize              = size(signal);
signalSize              = signalSize(1);
frameLength             = Setting.frame_length; % # samples needed to encode 1 bit
segmentCount            = floor(signalSize/frameLength);  % theoretical max amount of segments fitting in this signal, assuming the payload is encoded at sample nr 1
syncSequenceLen         = Setting.synccode_block_sequence_length; % amount of bits in one synccode
wmkSequenceLen          = Setting.wmkdata_block_sequence_length;  % amount of bits in one wmk sequence
syncSampleLen           = Setting.synccode_block_sample_length; % amount of samples needed to encode one synccode
wmkSampleLen            = Setting.wmkdata_block_sample_length;  % amount of samples needed to encode one wmk data block
dataStructSampleLen     = Setting.datastruct_package_sample_length;
dataStructSequenceLen   = Setting.datastruct_package_sequence_length;
dataStructCapacity      = floor(signalSize/dataStructSampleLen);
maxWmkSeqCount          = floor(segmentCount / dataStructSequenceLen ); % there is always a sync sequence and a wmk sequence encoded together
maxWmkBitcount          = maxWmkSeqCount * wmkSequenceLen;
wmkBuffer               = zeros([1, maxWmkBitcount(1)]); % preallocate wmk buffer space for speed
messageLength           = Setting.message_length;
codewordLength          = Setting.codeword_length;

wmkBufferCursor = 1;
sampleCursor    = 1;
dataStructCount = 0;

% Calculate the last sample it makes sense to start searching in. After
% this point, the signal is not able to hold and entire sync code +
% corresponting watermark sequence. Therefore, the following bit are random
lastSampleToStartSearching = signalSize-dataStructSampleLen;


[ newSignal, success ] = resynchronize( signal );


fprintf('Extracted messages:\n');


while sampleCursor <= lastSampleToStartSearching
    
    syncCodeWindow = sampleCursor : sampleCursor+syncSampleLen-1;% -1 due to the nature of matlab sequence notation
    
    % check if following segments hold a synccode
    syncCodeFound = synccodedetector(signal(syncCodeWindow), frameLength);
    
    if syncCodeFound
        % GOOD! this means the next X samples will hold information data
        
        % move sample cursor behind the end of the synccode window
        sampleCursor = sampleCursor + syncSampleLen;
        
        wmkDataWindow = sampleCursor : sampleCursor+wmkSampleLen-1;
        wmkData = wmkdataextractor(signal(wmkDataWindow));
        
        wmkBuffer(wmkBufferCursor : wmkBufferCursor+messageLength-1) = wmkData;
        wmkBufferCursor = wmkBufferCursor+messageLength;
        
        % ---------------------------------
        % this is a just informative output
        fmt=[repmat('%d ',1,messageLength) '--> %d\n'];
        wmk_dec = bi2de(wmkData','left-msb');
        fprintf(fmt,wmkData', wmk_dec);
        % ---------------------------------
       
        % move sample cursor to the end of the window
        sampleCursor = sampleCursor + wmkSampleLen;
        
        dataStructCount = dataStructCount+1;
    else
        % BAD! shift sample cursor and try again
        sampleCursor = sampleCursor+100;
    end
    
    if dataStructCount > dataStructCapacity
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


