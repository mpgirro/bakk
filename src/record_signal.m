
% records a audio sample
% see http://www.mathworks.de/de/help/matlab/import_export/record-and-play-audio.html

samplerate = 48000;
bitdepth = 16;
channel = 2;
recordingduration = 10;

recObj = audiorecorder(samplerate, bitdepth, channel);
disp('Start recording.');
recordblocking(recObj, recordingduration);
disp('End of Recording.');

recordingSignal = getaudiodata(recObj);

path = ['results',filesep,'recording.wav'];
audiowrite('results/recording.wav',  recordingSignal,  samplerate);
fprintf('Recording written to %s\n', path);