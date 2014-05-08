function [ rs_data ] = rsencode( pure_data )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

messageLength  = Setting.message_length;
codewordLength = Setting.codeword_length;

hEnc = comm.RSEncoder('MessageLength', messageLength, 'CodewordLength', codewordLength, 'BitInput', true);
rs_data  = step(hEnc, pure_data');

end