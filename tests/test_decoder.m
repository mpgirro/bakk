
addpath('../');

path   = ['..',filesep,'results',filesep,'watermarked_audio.wav'];

[signal,fs] = audioread(path);

decoder(signal)