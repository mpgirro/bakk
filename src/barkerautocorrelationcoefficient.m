function [ autocorrelation_coefficient ] = barkerautocorrelationcoefficient( signalCode )
% Calculate the barker autocorrelation coefficient for a given code
% sequence. The coefficient is normalized to the codelength to make sync
% threshold in the settings independent of sync code length.

syncCode = Setting.sync_code;
N = Setting.synccode_block_sequence_length;

N = size(signalCode);
N = N(2);

% make 0/1 signal code to a barker code (-1/+1)
signalCode(signalCode==0) = -1;
syncCode(syncCode == 0) = -1;

v = Setting.barker_threshold;
c = 0;

for i=1:N
    c = c + syncCode(i)*signalCode(i);
end

autocorrelation_coefficient = double(c) / double(N);

end

