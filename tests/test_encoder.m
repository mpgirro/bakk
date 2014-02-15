
clear;

addpath('../');

wmkData = repmat([1,1,1,1,0,0,0,0],1,1000);
%wmkData = [1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0];

%inputPath   = ['..',filesep,'resources',filesep,'audio',filesep,'der-affe-ist-gut.wav'];
inputPath   = ['..',filesep,'resources',filesep,'audio',filesep,'flute.wav'];
outputPath  = ['..',filesep,'results',filesep,'watermarked_audio.wav'];

[signal,fs] = audioread(inputPath);

[modSignal, encodedBitCount] = encoder(signal, wmkData, fs);

dataStructLen = Setting.synccode_block_sequence_length + Setting.wmk_block_sequence_length; % in bit
encodedStructCount = floor(encodedBitCount/dataStructLen);
%fprintf('Encoded %d bit total in %d data struct packages holding %d watermark bit\n',encodedBitCount,encodedStructCount, encodedStructCount * Setting.wmk_sequence_length);

audiowrite(outputPath,modSignal, fs);
fprintf('Result written to %s\n',outputPath);