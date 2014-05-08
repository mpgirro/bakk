
clear;

addpath('../');

path = ['..',filesep,'results',filesep,'watermarked_audio.wav'];
%path = ['..',filesep,'results',filesep,'DA-AD-test-3.wav'];

[signal,fs] = audioread(path);

watermark = decoder(signal);

messageLength = Setting.message_length;
wmk_bin = reshape(watermark, messageLength, numel(watermark)/messageLength)';
wmk_dec = bi2de(wmk_bin,'left-msb');

disp('    Dec              Binary')
disp('   -----   -------------------------')
disp([wmk_dec,wmk_bin])

% watermark = watermark';
% bitCount = size(watermark);
% fprintf('Decoded %d watermark bits\n',bitCount(1));
% fmt=['Watermark data: ' repmat('%d ',1,bitCount(1)) '\n'];
% fprintf(fmt,watermark);