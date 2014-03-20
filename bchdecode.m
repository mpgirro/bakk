function [ pure_data ] = bchdecode( bhc_data )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

hDec = comm.BCHDecoder;
pure_data = step(hDec, bhc_data');

end

