function [ message ] = ecc_decode( codeword )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

ecm = Setting.error_correcion_methode;

switch ecm
    case 'LR'
        % TODO local redundancy
    case 'BCH'
        message = bchdecode(codeword);
    case 'RS'
        message = rsdecode(codeword);
    case 'LDPC'
        message = ldpcdecode(codeword);
    case 'none'
        message = codeword;
end

end

