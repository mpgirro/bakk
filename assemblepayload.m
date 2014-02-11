function [ payload ] = assemblepayload( watermark )
%UNTITLED Assambles the payload that is to be encoded into a signal
%   A Watermark can not just be encoded by itself. Due to TSM and for WMK
%   detection there have to be synchronization code segments, that are 
%   hopefully distinctivly detectable without any false positive error. 
%   The payload consists of two parts. The synchronisation code and the
%   watermark data. There is always a whole synchronization code followed
%   by X bit of watermark data. Then there is a synchronization code
%   segment again. If the watermark data does not satisfy 
%   (data mod wmk_segment_length = 0), then the watermark has to be
%   extended with dummy bits. 

syncCode = Setting.sync_code;
syncSegmentLength = Setting.sync_segment_length;
wmkSegmentLength = Setting.wmk_segment_length;

wmkSize = size(watermark);



% check if watermark needs dummy bits
% extend watermark if need be
mod(wmkSize(2), wmkSegmentLength)
if mod(wmkSize(2), wmkSegmentLength) ~= 0
   missing = wmkSegmentLength - mod(wmkSize(2), wmkSegmentLength);
   watermark(wmkSize(2)+1: wmkSize(2)+missing) = 0;
   wmkSize = size(watermark);
end


wmkSegmentCount = ceil(wmkSize(2)/wmkSegmentLength);


% reshape the watermark, so we can index the segments easily
watermark = reshape(watermark, wmkSegmentLength, wmkSegmentCount);
watermark = watermark';


% for each wmk_segment there is a sync_code
% therefore total payload length is as follows:
payloadLength = syncSegmentLength * wmkSegmentCount + wmkSegmentLength * wmkSegmentCount;

payload = zeros([1, payloadLength]); % preallocate 1 x bitCount array 

windowStart = 1;
windowEnd = syncSegmentLength;
for i=1:wmkSegmentCount
    
    % insert sync code
    payload(windowStart:windowEnd) = syncCode;
    windowStart = windowStart   + syncSegmentLength;
    windowEnd   = windowEnd     + syncSegmentLength;
    
    % insert watermark segment
    payload(windowStart:windowEnd) = watermark(i,:);
    windowStart = windowStart   + wmkSegmentLength;
    windowEnd   = windowEnd     + wmkSegmentLength;
    
end




end

