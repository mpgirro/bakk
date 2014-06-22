function [codeword] = ldpcencode( message )
% Encode message with LDPC code
% see: http://www.mathworks.de/de/help/comm/ref/comm.ldpcencoder-class.html

hEnc = comm.LDPCEncoder;;
codeword = step(hEnc, message');

end

