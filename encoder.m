function [modSignal,fs] = encoder( inputData, inputType )

addpath('PQevalAudio');
addpath('PQevalAudio/CB');
addpath('PQevalAudio/MOV');
addpath('PQevalAudio/Misc');
addpath('PQevalAudio/Patt');


payload = [1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0];

if nargin < 1
	path = ['resources',filesep,'audio',filesep,'flute.wav'];
	[signal,fs] = audioread(path);
else
	switch inputType
		case 'path'
			path = inputData;
			[signal,fs] = audioread(path);
		case 'data'
			signal = inputData{1};
			fs = inputData{2};
			payload = inputData{3};
	end
end



% resample if need be - PQevalAudio only works with 48kHz
if fs ~= 48000
    signal = resample(signal, 48000, fs);
    fs = 48000;
end

origSignal = signal;

% aplayer = audioplayer(signal,fs);
% aplayer.play();

%plot( [1:size(signal)], signal)

segmentLength = (3*AlgoSettings.SUBBAND_LENGTH * 2 ^ AlgoSettings.DWT_LEVELS); % (3L * 2^k * (Lw+Ls), segment length to encode 1 bit (Lw+Ls=1, dwt level k=6, subband length L=8)
segmentCount = floor(size(signal)/segmentLength);

windowStart=1;
windowEnd = segmentLength;
for i=1:segmentCount
    
    % if whole payload is inserted we do not need to continue
    if i > size(payload)
        break;
    end
        
	% insert bit into segment
    signalSegment = signal(windowStart:windowEnd);
    modSignalSegment = insertbit(signalSegment,payload(i));
    signal(windowStart:windowEnd) = modSignalSegment;

	% move the window to the next slice
    windowStart = windowStart + segmentLength;
    windowEnd = windowEnd + segmentLength;
end

modSignal = signal;

audiowrite('watermarked_audio.wav',modSignal, 48000);
    
%plot( [1:size(signal)], signal)

% aplayer = audioplayer(modSignal,48000);
% aplayer.play();

end


