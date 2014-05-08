function [ message ] = bchdecode( codeword )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

hDec = comm.BCHDecoder;
message = step(hDec, codeword');

end

