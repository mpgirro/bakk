function [ pure_data ] = rsdecode( rs_data )
% Decode a RS codeword


messageLength  = Setting.message_length;
codewordLength = Setting.codeword_length;

hDec = comm.RSDecoder('MessageLength', messageLength, 'CodewordLength', codewordLength, 'BitInput', true);
pure_data = step(hDec, rs_data');

end

