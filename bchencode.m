function [ codeword ] = bchencode( message )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

hEnc = comm.BCHEncoder;
codeword = step(hEnc, message');

end

