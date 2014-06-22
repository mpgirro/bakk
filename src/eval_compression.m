% Testscript for evaluating compression impact on watermarked signals

testfiles = dir(['..',filesep,'results',filesep,'watermarked-holgi-compressed*']);

for i=1:numel(testfiles)
   testfile = ['..',filesep,'results',filesep,testfiles(i).name];
   
   fprintf('testing %s\n', testfile);
   [signal,fs] = audioread(testfile);
   wmk = eval_decoder(signal);
    
end