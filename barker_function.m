function [ autocorrelation_coefficient ] = barker_function( signalCode )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

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

autocorrelation_coefficient = c;

end

