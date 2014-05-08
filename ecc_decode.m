function [ message ] = ecc_decode( codeword )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

ecm = Setting.error_correcion_methode;

switch ecm
    case 'LR'
        % TODO
    case 'BCH'
        message = bchencode(codeword);
    case 'RS'
        message = rsencode(codeword);
    case 'LDPC'
        message = ldpcencode(codeword);
    case 'none'
        message = codeword;
end

end

