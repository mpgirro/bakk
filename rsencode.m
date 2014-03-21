function [ rs_data ] = rsencode( pure_data )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

hEnc = comm.RSEncoder;
rs_data  = step(hEnc, pure_data');

end