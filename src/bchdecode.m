function [ message ] = bchdecode( codeword )
% Decode a BCH codeword
%
% Copyright (C) 2013-2014, Maximilian Irro <max@disposia.org>
%

hDec = comm.BCHDecoder;
message = step(hDec, codeword');

end

