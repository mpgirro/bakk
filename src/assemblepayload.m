function [ payload, payloadSize ] = assemblepayload( watermark )
% Assambles the payload that is to be encoded into a signal. Information
% can not just be encoded by itself. Due to TSM and for watermark (wmk)
% detection, there have to be be synchonisation code segments, that are
% hopefully distinctivly detectable without any false positive error. The 
% payload consists of two parts. The synchronisation code and the
% information data. There is always a whole synchronization code followed
% by X bit of watermark data.

syncCode = Setting.sync_code;
syncBlockSequenceLength  = Setting.synccode_block_sequence_length;
dataStructBlockSequenceLength = Setting.datastruct_package_sequence_length;

messageLength = Setting.message_length;
codewordLength = Setting.codeword_length;

wmkSize = size(watermark);
wmkSize = wmkSize(2);

% how many messages would fit into the signal
wmkBlockCount = floor(wmkSize/codewordLength);

 % how much bigger is a codeword compared to the message
codemessageRatio = codewordLength / messageLength;

% how much longer the coded watermark will be
codeSize = wmkSize * codemessageRatio;

% how many blocks will the codewords need
codeBlockCount = ceil(codeSize/codewordLength);

% reshape the watermark, so we can index the segments easily
watermark = reshape(watermark, messageLength, codeBlockCount);
%watermark = reshape(watermark, wmkBlockSequenceLength, wmkBlockCount);
watermark = watermark';

% for each wmk_segment there is a sync_code
% therefore total payload length is as follows:
payloadLength = dataStructBlockSequenceLength * codeBlockCount;
%payloadLength = dataStructBlockSequenceLength * wmkBlockCount;

payload = zeros([1, payloadLength]); % preallocate 1 x bitCount array

payloadCursor = 1;
for i=1:codeBlockCount
    
    window = payloadCursor : payloadCursor+syncBlockSequenceLength-1;
    
    % insert sync code
    payload(window) = syncCode;
    
    % move cursor to the next wmk data block
    payloadCursor = payloadCursor+syncBlockSequenceLength;

    window = payloadCursor : payloadCursor+codewordLength-1;
    
    % insert watermark block
    messageBlock = watermark(i,:);
    codewordBlock = ecc_encode(messageBlock);
    payload(window) = codewordBlock;
    
%     fmt=[repmat('%d ',1,messageLength) ' ==ecc==> ' repmat('%d ',1,codewordLength) '\n'];
%     fprintf(fmt,messageBlock',codewordBlock');
    
    % move cursor to the next sync block
    payloadCursor = payloadCursor + codewordLength;
    
end

payloadSize = numel(payload);

end

