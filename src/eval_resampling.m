% Testscript to evaluate resampling impact on watermarked signals
%
% Copyright (C) 2013-2014, Maximilian Irro <max@disposia.org>
%

origfilepath = ['..',filesep,'results',filesep,'watermarked-holgi.wav'];
[origfilepathstr,origfilename,origfileext] = fileparts(origfilepath);
[origsignal,fs] = audioread(origfilepath);

samplerates = [22050, 44100, 48000, 11025, 8000];

for i=1:numel(samplerates)
    
    reffs = samplerates(i);
    
    fprintf('resampling %s to %d\n', origfilepath, reffs);
    
    [P,Q] = rat(reffs/fs);
    resample_sig = resample(origsignal,P,Q);
    
    newsigpath = ['..',filesep,'results',filesep,origfilename,'-resampled-',num2str(reffs),origfileext];
    fprintf('writing result to %s\n', newsigpath);
    audiowrite(newsigpath,resample_sig, reffs);
    
     eval_decoder(resample_sig);
end