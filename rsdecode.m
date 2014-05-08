function [ pure_data ] = rsdecode( rs_data )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


messageLength  = Setting.message_length;
codewordLength = Setting.codeword_length;

hDec = comm.RSDecoder('MessageLength', messageLength, 'CodewordLength', codewordLength, 'BitInput', true);
pure_data = step(hDec, rs_data');

end

