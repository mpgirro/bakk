
addpath('../');

wmkData = [1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0];

inputPath   = ['..',filesep,'resources',filesep,'audio',filesep,'flute.wav'];
outputPath  = ['..',filesep,'results',filesep,'watermarked_audio.wav'];

[signal,fs] = audioread(path);

[modSignal, encodedBitCount] = encoder(signal, wmkData);

dataStructLen = Setting.sync_sequence_length + Setting.wmk_sequence_length; % in bit
encodedStructCount = floor(encodedBitCount/dataStructLen);
fprintf('Encoded %d bit total in %d data struct packages holding %d watermark bit\n',encodedBitCount,encodedStructCount, encodedStructCount * Setting.wmk_sequence_length);

audiowrite(outputPath,modSignal, fs);
fprintf('Result written to %s\n',path);