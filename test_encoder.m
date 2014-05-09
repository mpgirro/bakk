
clear;

%wmkData = repmat([1,1,1,0,0],1,1000);

% create a matrix as wide as the message blocks 
% and filled with the binary numbers from 0 to 2^messageBlock-1
messageLength = Setting.message_length;
max_binnum = 2 ^ messageLength - 1;
bin_numbers = de2bi(0:max_binnum,'left-msb');
informationData = reshape(bin_numbers',1,numel(bin_numbers));

%inputPath   = ['resources',filesep,'der-affe-ist-gut.wav'];
%inputPath   = ['resources',filesep,'ISP-leicht-gemacht.m4a'];
inputPath   = ['resources',filesep,'flute.wav'];
outputPath  = ['results',filesep,'watermarked_audio.wav'];

[signal,fs] = audioread(inputPath);
[modSignal, encodedBitCount] = encoder(signal, informationData, fs);

dataStructLen = Setting.synccode_block_sequence_length + Setting.wmkdata_block_sequence_length; % in bit
% encodedStructCount = floor(encodedBitCount/dataStructLen);
% fprintf('Encoded %d bit total in %d data struct packages holding %d watermark bit\n',encodedBitCount,encodedStructCount, encodedStructCount * Setting.wmk_sequence_length);

audiowrite(outputPath,modSignal, fs);
fprintf('Result written to %s\n',outputPath);