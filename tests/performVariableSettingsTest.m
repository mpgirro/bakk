% NOTE: In order to run this test, you have to lift the constant constraints 
% on the propertys of the AlgoConst Class!
%
% This script insert a random sequence of bits into  audio files and check
% for false classification if 0s and 1s. The same test will be repeated with
% the (normally fixed) algorithm constant variated to evaluate the performance
% and/or application problems with every setting. 
% The results will be written in an excel sheet. 

PAYLOAD_LENGTH = 1000;
XLS_PATH = 'results-variable-settings-test.xls';


path = ['resources',filesep,'audio',filesep,'der-affe-ist-gut.wav'];
[signal,fs] = audioread(path);

% create random payload
payload = round(rand(PAYLOAD_LENGTH,1));

encodingData = {signal, fs, payload};

resultArray = {{'Wavelet' 'DWT Level' 'Subband Length' 'Strength Factor'  'inserted [bit]' 'misclassified' 'ODG (PQevalAudio)'}};
settingsCount = 1;

% do for every possible combinartion of settings
for wavelet = {'db1', 'db2', 'db3'}	
	for dwtLevel = [1:10]
		for subbandLength = [5:15]
			for strengthFactor = [1:10]
				
				fprintf('Performing test for Wavelet: %s | Level: %g | Length: %g | Strength: %g\n', wavelet, dwtLevel,subbandLength,strengthFactor);
				
				% set new temporary algorithm settings
		        AlgoSettings.DWT_WAVELET = wavelet;
		        AlgoSettings.DWT_LEVELS = dwtLevel;
		        AlgoSettings.SUBBAND_LENGTH = subbandLength;
		        AlgoSettings.EMBEDDING_STRENGTH_FACTOR = strengtFactor;
				
				% insert payload into signal
				[resultSignal, encodedBitCount] = encoder( encodingData, 'data' );
				
				% decode payload from new signal
				decodingData = {resultSignal, fs};
				[decodedPayload, decodedBitCount] = decoder(decodingData,'signal');
				
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
				
				% calculate ODG with PQevalAudio
				odg_PQ = odgFromPQevalAudioBinary( signal, fs, resultSignal, fs);

				% add results to the resultArray
				resultRow = {wavelet dwtLevel subbandLength strengtFactor encodedBitCount misclassifiedBits odg_PQ};
				resultRow = cellfun(@num2str, resultRow);

				settingsCount = settingsCount + 1;
				resultArray{settingsCount} = resultRow;
			end			
		end
	end
end

xlswrite(XLS_PATH,resultArray)

fprintf('Tests finished\n');

