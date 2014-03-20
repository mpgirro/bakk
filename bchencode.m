function [ bhc_data ] = bchencode( pure_data )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

hEnc = comm.BCHEncoder;
bhc_data = step(hEnc, pure_data');

end

