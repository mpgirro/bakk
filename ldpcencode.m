function [codeword] = ldpcencode( message )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%
% 	http://www.mathworks.de/de/help/comm/ref/comm.ldpcencoder-class.html
%

hEnc = comm.LDPCEncoder;;
codeword = step(hEnc, message');

end

