function [payloadBuffer, payloadLength] = decoder( inputData, inputType )

addpath('PQevalAudio/CB');
addpath('PQevalAudio/MOV');
addpath('PQevalAudio/Misc');
addpath('PQevalAudio/Patt');



if nargin < 1
	path = 'watermarked_audio.wav';
	[signal,fs] = audioread(path);
else
	switch inputType
		case 'path'
			path = inputData;
			[signal,fs] = audioread(path);
		case 'signal'
			signal = inputData{1};
			fs = inputData{2};
	end
end

segmentLength = (3*AlgoSettings.SUBBAND_LENGTH * 2 ^ AlgoSettings.DWT_LEVELS); % (3L * 2^k * (Lw+Ls), segment length to encode 1 bit (Lw+Ls=1, dwt level k=6, subband length L=8)
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

payloadLength = i; % how many bits did we read?

end

% TODO: delete the sync sequence from the payload

