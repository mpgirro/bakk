function [ codeword ] = bchencode( message )
% Encode message with BCH code
%
% Copyright (C) 2013-2014, Maximilian Irro <max@disposia.org>
%

hEnc = comm.BCHEncoder;
codeword = step(hEnc, message');

end

