
addpath('PQevalAudio');
addpath('PQevalAudio/CB');
addpath('PQevalAudio/MOV');
addpath('PQevalAudio/Misc');
addpath('PQevalAudio/Patt');


path = ['..',filesep,'Audio',filesep,'Test Snippets',filesep,'flute.wav'];
[signal,fs] = wavread(path);

% resample if need be - PQevalAudio only works with 48kHz
if fs ~= 48000
    signal = resample(signal, 48000, fs);
    fs = 48000;
end

origSignal = signal;

% aplayer = audioplayer(signal,fs);
% aplayer.play();

%plot( [1:size(signal)], signal)

payload = [1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0];

segment_length = (3*8 * 64); % (3L * 2^ * (Lw+Ls), segment length to encode 1 bit
segment_count = floor(size(signal)/segment_length);

window_start=1;
window_end = segment_length;
for i=1:segment_count
    
    signal_segment = signal(window_start:window_end);
    
    mod_signal_segment = encode_bit(signal_segment,payload(i));
    
    signal(window_start:window_end) = mod_signal_segment;
    
    window_start = window_start + segment_length;
    window_end = window_end + segment_length;
end

modSignal = signal;

% we need to resample
if fs ~= 48000
    origSignal = resample(origSignal, 48000, fs);
    modSignal = resample(modSignal, 48000, fs);
end
    
%plot( [1:size(signal)], signal)

% aplayer = audioplayer(signal,fs);
% aplayer.play();


% wavwrite(signal,fs,'test.wav')



