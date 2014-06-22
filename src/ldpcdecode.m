function [ message ] = ldpcdecode( codeword )
% Decode a LDPC codeword

hDec = comm.LDPCDecoder;
message = step(hDec, codeword');

end

