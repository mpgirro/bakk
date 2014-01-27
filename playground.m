PAYLOAD_LENGTH = 1000;
XLS_PATH = 'results-variable-settings-test.xls';


path = ['resources',filesep,'audio',filesep,'der-affe-ist-gut.wav'];
[signal,fs] = audioread(path);

% create random payload
payload = round(rand(PAYLOAD_LENGTH,1));

encodingData = {signal, fs, payload};

settingsCount = 1;
resultArray = ['Wavelet','DWT Level','Subband Length','Strength Factor', 'inserted [bit]', 'misclassified', 'ODG (PQevalAudio)'];

% set new temporary algorithm settings
wavelet = AlgoSettings.DWT_WAVELET;
dwtLevel = AlgoSettings.DWT_LEVELS;
subbandLength = AlgoSettings.SUBBAND_LENGTH;
strengthFactor = AlgoSettings.EMBEDDING_STRENGTH_FACTOR;

fprintf('Performing test for Wavelet: %s | Level: %g | Length: %g | Strength: %g\n', wavelet, dwtLevel,subbandLength,strengthFactor);

% insert payload into signal
[resultSignal, encodedBitCount] = encoder( encodingData, 'data' );
fprintf('Encoded: %g bits\n', encodedBitCount);

% decode payload from new signal
decodingData = {resultSignal, fs};
[decodedPayload, decodedBitCount] = decoder(decodingData,'signal');
fprintf('Decoded: %g bits\n', decodedBitCount);

% + compare payloads
misclassifiedBits = 0;

% the first 1..encodedBitCount decoded bits can be part of the real payload
% the rest is just classified due to the nature of the signal and holds no
% true encoded data
for i=1:encodedBitCount 	
	if payload(i) ~= decodedPayload(i)
		misclassifiedBits = misclassifiedBits + 1;
	end	
end
fprintf('misclassified: %g bits\n', misclassifiedBits);

% calculate ODG with PQevalAudio
odg_PQ = odgFromPQevalAudioBinary( signal, fs, resultSignal, fs);

% add results to the resultArray
resultRow = [wavelet, dwtLevel, subbandLength, strengtFactor, encodedBitCount, misclassifiedBits, odg_PQ];

resultArray(settingsCount);
settingsCount = settingsCount + 1;


xlswrite(XLS_PATH,resultArray)

fprintf('Test finished\n');