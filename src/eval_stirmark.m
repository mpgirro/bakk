% Testscript to evaluate Stirmark for Audio attacked watermarked signals
%
% Copyright (C) 2013-2014, Maximilian Irro <max@disposia.org>
%

evalfile = ['..',filesep,'results',filesep,'watermarked-holgi.wav'];
[evalfilepathstr,evalfilename,evalfileext] = fileparts(evalfile);

% read the signal of the watermarked files
disp(['#############',' evaluating ', evalfile, ' #############']);
[evalfilesignal,fs] = audioread(evalfile);
evalfilewmk = eval_decoder(evalfilesignal);

attackedfiles = dir(['..',filesep,'results',filesep,'watermarked-holgi-attacked-*',evalfileext]);
afsSize = size(attackedfiles);

for i=1:afsSize(1)
    
    disp(['#############',' evaluating ', attackedfiles(i).name, ' #############']);
    
    afpath=['..',filesep,'results',filesep,attackedfiles(i).name];
    
    [attacksignal,fs] = audioread(afpath);
    attackwmk = eval_decoder(attacksignal);
    if numel(attackwmk) == numel(evalfilewmk)
        [num_errbit,ber_ratio] = biterr(evalfilewmk,attackwmk, 'row-wise');
        fprintf('Total wrong message bits: %d\n',num_errbit);
        fprintf('BER %2.2f%%\n',ber_ratio*100);
    else
        fprintf('Decoded WMK has %d bits!\n',numel(attackwmk));
    end
end