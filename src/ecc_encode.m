function [ codeword ] = ecc_encode( message )
% Encode a message with an ECC set in the Settings
%
% Copyright (C) 2013-2014, Maximilian Irro <max@disposia.org>
%

ecm = Setting.error_correcion_methode;

switch ecm
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

