function [ payload ] = assemblepayload( watermark )
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
wmkBlockSequenceLength   = Setting.wmkdata_block_sequence_length;
dataStructBlockSequenceLength = Setting.datastruct_package_sequence_length;

wmkSize = size(watermark);
wmkSize = wmkSize(2);

% check if watermark needs dummy bits
% extend watermark if need be
if mod(wmkSize, wmkBlockSequenceLength) ~= 0
    missing = wmkBlockSequenceLength - mod(wmkSize, wmkBlockSequenceLength);
    watermark(wmkSize+1: wmkSize+missing) = 0;
    wmkSize = size(watermark);
    wmkSize = wmkSize(2);
end


wmkBlockCount = ceil(wmkSize/wmkBlockSequenceLength);


% reshape the watermark, so we can index the segments easily
watermark = reshape(watermark, wmkBlockSequenceLength, wmkBlockCount);
watermark = watermark';


% for each wmk_segment there is a sync_code
% therefore total payload length is as follows:
payloadLength = dataStructBlockSequenceLength * wmkBlockCount;

payload = zeros([1, payloadLength]); % preallocate 1 x bitCount array


payloadCursor = 1;
for i=1:wmkBlockCount
    
    window = payloadCursor : payloadCursor+syncBlockSequenceLength-1;
    
    % insert sync code
    payload(window) = syncCode;
    
    % move cursor to the next wmk data block
    payloadCursor = payloadCursor+syncBlockSequenceLength;

    
    window = payloadCursor : payloadCursor+wmkBlockSequenceLength-1;
    
    % insert watermark block
    payload(window) = watermark(i,:);
    
    % move cursor to the next sync block
    payloadCursor = payloadCursor + wmkBlockSequenceLength;
    
end




end

