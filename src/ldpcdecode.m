function [ message ] = ldpcdecode( codeword )
% Decode a LDPC codeword
%
% Copyright (C) 2013-2014, Maximilian Irro <max@disposia.org>
%

hDec = comm.LDPCDecoder;
message = step(hDec, codeword');

end

