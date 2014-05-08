function [ payload, payloadSize ] = assemblepayload( watermark )
%UNTITLED Assambles the payload that is to be encoded into a signal
%   A Watermark can not just be encoded by itself. Due to TSM and for WMK
%   detection there have to be synchronization code segments, that are
%   hopefully distinctivly detectable without any false positive error.
%   The payload consists of two parts. The synchronisation code and the
%   watermark data. There is always a whole synchronization code followed
%   by X bit of watermark data. Then there is a synchronization code
%   segment again. If the watermark data does not satisfy
%   (data mod wmk_sequence_length = 0), then the watermark has to be
%   extended with dummy bits.

% TODO: Update comments above:
% the watermark must be only as long as the audio signal samples can hold
% the error-corrected-encoded-watermark which should be (depending on the
% encoding) abourt 1/3 of the bit capacity. if this hold, the payload
% returned by this function is ensured to fit in the watermark

syncCode = Setting.sync_code;
syncBlockSequenceLength  = Setting.synccode_block_sequence_length;
dataStructBlockSequenceLength = Setting.datastruct_package_sequence_length;

messageLength = Setting.message_length;
codewordLength = Setting.codeword_length;

wmkSize = size(watermark);
wmkSize = wmkSize(2);

% % check if watermark needs dummy bits
% % extend watermark if need be
% % Note: This should never happen --> ensured by encoder
% if mod(wmkSize, codewordLength) ~= 0
%     missing = codewordLength - mod(wmkSize, codewordLength);
%     watermark(wmkSize+1: wmkSize+missing) = 0;
%     wmkSize = size(watermark);
%     wmkSize = wmkSize(2);
% end

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


% fprintf('wmk size: %d\n',wmkSize);
% fprintf('codeSize: %d\n',codeSize);
% fprintf('codeBlockCount: %d\n',codeBlockCount);
% size(watermark)


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

