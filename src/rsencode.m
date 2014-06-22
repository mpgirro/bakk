function [ rs_data ] = rsencode( pure_data )
% Encode message with RS code

messageLength  = Setting.message_length;
codewordLength = Setting.codeword_length;

hEnc = comm.RSEncoder('MessageLength', messageLength, 'CodewordLength', codewordLength, 'BitInput', true);
rs_data  = step(hEnc, pure_data');

end