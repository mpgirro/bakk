function [ message ] = bchdecode( codeword )
% Decode a BCH codeword

hDec = comm.BCHDecoder;
message = step(hDec, codeword');

end

