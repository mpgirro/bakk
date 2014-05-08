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
packageBitLen   = Setting.datastruct_package_sequence_length;
packageSampleLen     = Setting.datastruct_package_sample_length;
messageLength   = Setting.message_length;
codewordLength  = Setting.codeword_length;

packageCapacity  = floor( signalSize / packageSampleLen );
bitCapacity      = floor(signalSize/frameLength);

codewordBitCapacity = packageCapacity * wmkSequenceLen; % maximun amount of codewords capable of embedding
messageBitCapacity  = codewordBitCapacity / codewordLength * messageLength;

fprintf('Signal capacity analysis:\n');
fprintf('   %d bits total\n',bitCapacity);
fprintf('   %d information bits\n',messageBitCapacity);
fprintf('   %d packages\n',packageCapacity);
%fprintf('Maximum encoding capacity: %d information bits\n',codewordBitCapacity);

wmkLen = numel(watermark);
fprintf('Watermark consists of %d bits - ',wmkLen);
if codewordBitCapacity >= wmkLen
    fprintf('signal size sufficient\n');
else
    fprintf('signal to short, skipping %d watermark bits!\n', wmkLen-codewordBitCapacity);
end

% lower bound will be used to determin processed wmk data
wmkbound = min(codewordBitCapacity,wmkLen);

% create payload containing synccodes and watermark segments,
% only process as many watermark bits as can be encoded
fprintf('Assembling payload...');
[payload, payloadSize] = assemblepayload(watermark(1:wmkbound));
fprintf('DONE\n');

sampleCursor = 1;
dataStructCount = 0;

% Theoretical limit of bit that can be encoded into this sample sequence.
% In general, there will be less bits encoded, because we stop as soon as
% the signal can't hold any more data structures for we only encode whole
% structures.
bitEncodingCapacity = floor(signalSize/ frameLength );

fprintf('Processing signal...');

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
    
    if mod(i,packageBitLen) == 0
        dataStructCount = dataStructCount+1;
    end
    
    % Check if we reached the data structure limit this signal can hold. We
    % can stop if this is the case
    if dataStructCount >= packageCapacity
        break;
    end
    
end

modSignal = signal;
encodedBitCount = i;

fprintf('DONE\n');

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

fprintf('Encoding complete, written:\n');
fprintf('   %d bits total\n',encodedBitCount);
fprintf('   %d packages\n',dataStructCount);
fprintf('   %d information bits\n',dataStructCount * messageLength);
if eaqual_flag
    fprintf('ODG: %f (EAQUAL)\n',odg_eaqual);
end
if pqeval_flag
    fprintf('ODG: %f (PQevalAudio)\n',odg_pqeval);
    
end

end


