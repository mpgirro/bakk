% Testscript to evaluate signal subbands of an ad/da signals

clear;

%path = ['..',filesep,'results',filesep,'watermarked-flute.wav'];
path = ['..',filesep,'results',filesep,'watermarked-flute-windowed-soundkarte-cropped-amplified-22050.wav'];


fprintf('processing %s\n',path);
[signal,fs] = audioread(path);
watermark = eval_decoder(signal);

messageLength = Setting.message_length;
wmk_bin = reshape(watermark, messageLength, numel(watermark)/messageLength)';
wmk_dec = bi2de(wmk_bin,'left-msb');

disp('    Dec              Binary')
disp('   -----   -------------------------')
disp([wmk_dec,wmk_bin])