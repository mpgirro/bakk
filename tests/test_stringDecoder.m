clear;

addpath('../');

path = ['..',filesep,'results',filesep,'watermarked_audio.wav'];
%path = ['..',filesep,'results',filesep,'DA-AD-test-3.wav'];

[signal,fs] = audioread(path);

watermark = decoder(signal);

