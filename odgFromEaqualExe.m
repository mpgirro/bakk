function [odg] = odgFromEaqualExe( refSignal, refFs, testSignal, testFs)

% write signals to harddrive
audiowrite('../tmp/refSignal.wav',  refSignal,  refFs);
audiowrite('../tmp/testSignal.wav', testSignal, testFs);


command = '/Applications/Wine.app/Contents/Resources/bin/wine ../lib/bin/EAQUAL.exe -fref ../tmp/refSignal.wav -ftest ../tmp/testSignal.wav -silent ../tmp/eaqual-output.txt';

% http://www.mathworks.de/de/help/matlab/ref/system.html
[status,~] = system(command);

% http://www.mathworks.de/de/help/matlab/ref/unix.html
%[status,cmdout] = unix(command);

if status == 0 || status == 68 % system() return this, who knows why...
    
    % EAQUAL executed in silent mode - not output (matlab does not work
    % with executables which update their statues - it fails with an error
    % code). Instead the output is written into a txt file in ../tmp/
    output = textread('../tmp/eaqual-out.txt', '%s', 'delimiter', '\n', 'whitespace', '');
    
    cellValues = textscan(output{3},'%f');
    matValues = cell2mat(cellValues);
    odg = matValues(1);
else
    odg = NaN;
end

end