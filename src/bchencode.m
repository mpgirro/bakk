function [ codeword ] = bchencode( message )
% Encode message with BCH code

hEnc = comm.BCHEncoder;
codeword = step(hEnc, message');

end

