function [ pure_data ] = rsdecode( rs_data )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

hDec = comm.RSDecoder;
pure_data = step(hDec, rs_data');

end

