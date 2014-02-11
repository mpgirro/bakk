function [modSignal, encodedBitCount ] = encoder( inputSignal, watermark )

%  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

% addpath('PQevalAudio');
% addpath('PQevalAudio/CB');
% addpath('PQevalAudio/MOV');
% addpath('PQevalAudio/Misc');
% addpath('PQevalAudio/Patt');

% payload = [1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0];
% 
% if nargin < 1
% 	path = ['resources',filesep,'audio',filesep,'flute.wav'];
% 	[signal,fs] = audioread(path);
% else
% 	switch inputType
% 		case 'path'
% 			path = inputData;
% 			[signal,input_fs] = audioread(path);
% 		case 'data'
% 			signal = inputData{1};
% 			fs = inputData{2};
% 			payload = inputData{3};
% 	end
% end

% resample if need be - PQevalAudio only works with 48kHz
% if input_fs ~= 48000
%    signal = resample(signal, 48000, input_fs);
%    fs = 48000;
% end

%origSignal = inputSignal;

%  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

% create payload containing synccodes and watermark segments
payload = assemblepayload(watermark);

signal = inputSignal;

segmentLength = Setting.coefficient_segment_length;
segmentCount = floor(size(inputSignal)/segmentLength);

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
encodedBitCount = i-1;

% resample back to original 
% if fs ~= input_fs
% 	 signal = resample(signal, input_fs, 48000);
% end
%audiowrite('watermarked_audio.wav',modSignal, fs);
    
%plot( [1:size(signal)], signal)

% aplayer = audioplayer(modSignal,48000);
% aplayer.play();

end


