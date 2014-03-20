function [ bhc_data ] = bhcencode( pure_daza )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

hEnc = comm.BCHEncoder;
bhc_data = step(hEnc, pure_daza);

end

