
clear;

addpath('../');

path   = ['..',filesep,'results',filesep,'watermarked_audio.wav'];

[signal,fs] = audioread(path);

watermark = decoder(signal);

% watermark = watermark';
% bitCount = size(watermark);
% fprintf('Decoded %d watermark bits\n',bitCount(1));
% fmt=['Watermark data: ' repmat('%d ',1,bitCount(1)) '\n'];
% fprintf(fmt,watermark);