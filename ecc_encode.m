function [ codeword ] = ecc_encode( message )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

ecm = Setting.error_correcion_methode;

switch ecm
    
    case 'LR'
        % TODO local redundancy
    case 'BCH'
        codeword = bchencode(message);
    case 'RS'
        codeword = rsencode(message);
    case 'LDPC'
        codeword = ldpcencode(message);
    case 'none'
        codeword = message;
end

end

