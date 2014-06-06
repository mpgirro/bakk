function [ message ] = ldpcdecode( codeword )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

hDec = comm.LDPCDecoder;
message = step(hDec, codeword');

end

