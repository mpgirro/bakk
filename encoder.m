function [modSignal, encodedBitCount ] = encoder( inputSignal, watermark, fs )

signal = inputSignal;

frameLength     = Setting.frame_length;
frameDataSampleLen = Setting.frame_data_samples_length;
signalSize      = size(signal);
signalSize      = signalSize(1);
segmentCount    = floor( signalSize / frameLength );
syncSequenceLen = Setting.synccode_block_sequence_length; % amount of bits in one synccode
wmkSequenceLen  = Setting.wmkdata_block_sequence_length;  % amount of bits in one wmk sequence
syncSampleLen   = Setting.synccode_block_sample_length; % amount of samples needed to encode one synccode
wmkSampleLen    = Setting.wmkdata_block_sample_length;  % amount of samples needed to encode one wmk data block
dataStructSequenceLen   = Setting.datastruct_package_sequence_length;
dataStructSampleLen     = Setting.datastruct_package_sample_length;
dataStructCapacity = floor( signalSize / dataStructSampleLen );

wmkCapacity = dataStructCapacity * wmkSequenceLen; % maximun amount of bit capable of embedding
fprintf('Maximum encoding capacity: %d watermark bits\n',wmkCapacity);

% create payload containing synccodes and watermark segments,
% only process as many watermark bits as can be encoded
payload = assemblepayload(watermark(1:wmkCapacity));
payloadSize = size(payload);
payloadSize = payloadSize(2);

sampleCursor = 1;
dataStructCount = 0;

% Theoretical limit of bit that can be encoded into this sample sequence.
% In general, there will be less bits encoded, because we stop as soon as
% the signal can't hold any more data structures for we only encode whole
% structures.
bitEncodingCapacity = floor(signalSize/ frameLength );

for i=1:bitEncodingCapacity
    
    % no need to do more than necessary
    if i > payloadSize
        break;
    end
    
    window = sampleCursor : sampleCursor+frameLength-1;
    
    signalSegment = signal(window);
    modSignalSegment = insertbit(signalSegment,payload(i));
    signal(window) = modSignalSegment;
    
    sampleCursor = sampleCursor+frameLength;
    
    if mod(i,dataStructSequenceLen) == 0
        dataStructCount = dataStructCount+1;
    end
    
    % Check if we reached the data structure limit this signal can hold. We
    % can stop if this is the case
    if dataStructCount >= dataStructCapacity
        break;
    end
    
end

modSignal = signal;
encodedBitCount = i;

% % now lets calculate the ODGs if we can
refSignal   = inputSignal(1:sampleCursor-1);
testSignal  = modSignal(1:sampleCursor-1);

eaqual_flag = false;
odg_eaqual = +1; % undefined ODG value
try
    odg_eaqual = odgFromEaqualExe(refSignal, fs, testSignal, fs);
    eaqual_flag = true;
    
catch
    fprintf('Error calculating ODG with EAQUAL\n');
end

pqeval_flag = false;
odg_pqeval = +1; % undefined ODG value
try
    odg_pqeval = odgFromPQevalAudioBinary(refSignal, fs, testSignal, fs);
    pqeval_flag = true;
catch 
    fprintf('Error calculating ODG with PQevalAudio\n');
end

fprintf('Encoding complete\n');
fprintf('%d bit total payload\n',encodedBitCount);
fprintf('%d data struct packages\n',dataStructCount);
fprintf('%d watermark data bits\n',dataStructCount * wmkSequenceLen);
if eaqual_flag
    fprintf('ODG: %f (EAQUAL)\n',odg_eaqual);
end
if pqeval_flag
    fprintf('ODG: %f (PQevalAudio)\n',odg_pqeval);
    
end

end


