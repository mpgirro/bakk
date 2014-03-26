
clear;

addpath('../');

stringData = 'abcdefghijklmnopqrstuvqxyz';
wmkData = dec2bin(stringData,8)';
wmkData = (wmkData(:) - '0')';

%inputPath   = ['..',filesep,'resources',filesep,'audio',filesep,'der-affe-ist-gut.wav'];
inputPath   = ['..',filesep,'resources',filesep,'audio',filesep,'flute.wav'];
outputPath  = ['..',filesep,'results',filesep,'watermarked_audio.wav'];

[signal,fs] = audioread(inputPath);

[modSignal, encodedBitCount] = encoder(signal, wmkData, fs);

audiowrite(outputPath,modSignal, fs);
fprintf('Result written to %s\n',outputPath);