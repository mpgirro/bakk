
addpath('PQevalAudio/CB');
addpath('PQevalAudio/MOV');
addpath('PQevalAudio/Misc');
addpath('PQevalAudio/Patt');


path = 'watermarked_audio.wav';
[signal,fs] = audioread(path);

segmentLength = (3*AWA.SUBBAND_LENGTH * 2 ^ AWA.DWT_LEVELS); % (3L * 2^k * (Lw+Ls), segment length to encode 1 bit (Lw+Ls=1, dwt level k=6, subband length L=8)
segmentCount = floor(size(signal)/segmentLength);

payloadBuffer = [];
payloadLength = 0;

windowStart=1;
windowEnd = segmentLength;
for i=1:segmentCount
    
    signalSegment = signal(windowStart:windowEnd);
    
    bit = extractbit(signalSegment);
    
    % add the bit to the recovered payload 
    payloadLength = payloadLength + 1;
    payloadBuffer(payloadLength) = bit;
    
    windowStart = windowStart + segmentLength;
    windowEnd = windowEnd + segmentLength;
end

payloadBuffer

% TODO: delete the sync sequence from the payload

