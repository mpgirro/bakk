function [codeword] = ldpcencode( message )
% Encode message with LDPC code
% see: http://www.mathworks.de/de/help/comm/ref/comm.ldpcencoder-class.html
%
% Copyright (C) 2013-2014, Maximilian Irro <max@disposia.org>
%

hEnc = comm.LDPCEncoder;;
codeword = step(hEnc, message');

end

