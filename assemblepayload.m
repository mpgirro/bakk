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

syncCode = Setting.sync_code;
syncSequenceLength  = Setting.synccode_block_sequence_length;
wmkBlockSequenceLength   = Setting.wmkdata_block_sequence_length;

wmkSize = size(watermark);



% check if watermark needs dummy bits
% extend watermark if need be
if mod(wmkSize(2), wmkBlockSequenceLength) ~= 0
   missing = wmkBlockSequenceLength - mod(wmkSize(2), wmkBlockSequenceLength);
   watermark(wmkSize(2)+1: wmkSize(2)+missing) = 0;
   wmkSize = size(watermark);
end


wmkSegmentCount = ceil(wmkSize(2)/wmkBlockSequenceLength);


% reshape the watermark, so we can index the segments easily
watermark = reshape(watermark, wmkBlockSequenceLength, wmkSegmentCount);
watermark = watermark';


% for each wmk_segment there is a sync_code
% therefore total payload length is as follows:
payloadLength = syncSequenceLength * wmkSegmentCount + wmkBlockSequenceLength * wmkSegmentCount;

payload = zeros([1, payloadLength]); % preallocate 1 x bitCount array 

windowStart = 1;
windowEnd = syncSequenceLength;
for i=1:wmkSegmentCount
    
    % insert sync code
    payload(windowStart:windowEnd) = syncCode;
    windowStart = windowStart   + syncSequenceLength;
    windowEnd   = windowEnd     + syncSequenceLength;
    
    % insert watermark segment
    payload(windowStart:windowEnd) = watermark(i,:);
    windowStart = windowStart   + wmkBlockSequenceLength;
    windowEnd   = windowEnd     + wmkBlockSequenceLength;
    
end




end

