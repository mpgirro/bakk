function [watermark] = decoder( signal )

% addpath('PQevalAudio/CB');
% addpath('PQevalAudio/MOV');
% addpath('PQevalAudio/Misc');
% addpath('PQevalAudio/Patt');
% 
% 
% 
% if nargin < 1
% 	path = 'watermarked_audio.wav';
% 	[signal,fs] = audioread(path);
% else
% 	switch inputType
% 		case 'path'
% 			path = inputData;
% 			[signal,fs] = audioread(path);
% 		case 'signal'
% 			signal = inputData{1};
% 			fs = inputData{2};
% 	end
% end

% segmentLength = Setting.coefficient_segment_length; % (3L * 2^k * (Lw+Ls), segment length to encode 1 bit (Lw+Ls=1, dwt level k=6, subband length L=8)
% segmentCount = floor(size(signal)/segmentLength);
% 
% payloadBuffer = [];
% payloadLength = 0;
% 
% windowStart=1;
% windowEnd = segmentLength;
% for i=1:segmentCount
%     
%     signalSegment = signal(windowStart:windowEnd);
%     
%     bit = extractbit(signalSegment);
%     
%     % add the bit to the recovered payload 
%     payloadLength = payloadLength + 1;
%     payloadBuffer(payloadLength) = bit;
%     
%     windowStart = windowStart + segmentLength;
%     windowEnd = windowEnd + segmentLength;
% end
% 
% payloadLength = i; % how many bits did we read?



% ---

signalSize      = size(signal);
segmentWidth    = Setting.coefficient_segment_length; % # samples needed to encode 1 bit
segmentCount    = floor(size(signal)/segmentLength);  % theoretical max amount of segments fitting in this signal, assuming the payload is encoded at sample nr 1
syncSequenceLen = Setting.sync_sequence_length; % amount of bits in one synccode
wmkSequenceLen  = Setting.wmk_sequence_length;  % amount of bits in one wmk sequence 
syncSegmentLen  = syncSequenceLen * segmentWidth; % amount of samples needed to encode one synccode
wmkSegmentLen   = wmkSequenceLen * segmentWidth;
maxWmkBitcount  = segmentCount / (syncSequenceLen + wmkSequenceLen); % there is always a sync sequence and a wmk sequence encoded together
wmkBuffer       = zeros([1, maxWmkBitcount]); % preallocate wmk buffer space for speed
wmkBufferIndex  = 1;

sampleCursor = 1;

% Calculate the last sample it makes sense to start searching in. After
% this point, the signal is not able to hold and entire sync code +
% corresponting watermark sequence. Therefore, the following bit are random
lastSampleToStartSearching = signalSize(2)-(segmentWidth*syncSequenceLen + segmentWidth*wmkSequenceLen);

for i=1:lastSampleToStartSearching
    
    syncCodeWindow = sampleCursor : sampleCursor+syncSegmentLen-1;% -1 due to the nature of matlab sequence notation
    
    syncCodeFound = synccodedetector(signal(syncCodeWindow));
    
    if syncCodeFound
       % GOOD! this means the next X samples will hold watermark data
       
       % move sample cursor behind the end of the synccode window
       sampleCursor = sampleCursor + syncSegmentLen;
       
       wmkDataWindow = sampleCursor : sampleCursor+wmkSegmentLen-1;
       wmkData = wmkdataextractor(signal(wmkDataWindow));
       
       wmkBuffer(wmkBufferIndex : wmkBufferIndex+wmkSequenceLen-1) = wmkData;
       wmkBufferIndex = wmkBufferIndex+wmkSequenceLen;
       
       % move sample cursor to the end of the window
       sampleCursor = sampleCursor + wmkSegmentLen;
    else
        % BAD! shift sample cursor one element and try again
        sampleCursor = sampleCursor+1;
    end
    
    
end

if wmkBufferIndex = 1
    % oh boy, we did not find any sync codes and 
    % therefore have no watermark data
    watermark = [];
else
    % be preallocated space for the theoratically maximum of watermark data
    % bit. but in general we will not have found as many bit. so return
    % only the valid data
    watermark = wmkBuffer(1:wmkBufferIndex-1);
end

end


