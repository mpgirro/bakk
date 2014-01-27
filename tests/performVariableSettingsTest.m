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

settingsCount = 1;
resultArray = ['Wavelet','DWT Level','Subband Length','Strength Factor', 'inserted [bit]', 'misclassified'];

% do for every possible combinartion of settings
for wavelet = {'db1', 'db2', 'db3'}	
	for dwtLevel = [1:10]
		for subbandLength = [5:15]
			for strengthFactor = [1:10]
				
				fprintf('Performing test for Wavelet: %s | Level: %g | Length: %g | Strength: %g\n', wavelet, dwtLevel,subbandLength,strengthFactor);
				
				% set new temporary algorithm settings
		        AlgoConst.DWT_WAVELET = wavelet;
		        AlgoConst.DWT_LEVELS = dwtLevel;
		        AlgoConst.SUBBAND_LENGTH = subbandLength;
		        AlgoConst.EMBEDDING_STRENGTH_FACTOR = strengtFactor;
				
				% insert payload into signal
				[resultSignal, encodedBitCount] = encoder( encodingData, 'data' );
				
				% decode payload from new signal
				decodingData = {resultSignal, fs};
				[decodedPayload, decodedBitCount] = decoder(decodingData,'signal');
				
				% + compare payloads
				
				% + calculate odg with PQeval audio for whole signal - might not be good, but no harm in collecting the data
				
				% + write a function to get the odg with the binary!
				
				resultRow = [wavelet, dwtLevel, subbandLength, strengtFactor, ]
				
				resultArray(settingsCount)
				settingsCount = settingsCount + 1;
			end			
		end
	end
end

xlswrite(XLS_PATH,resultArray)

fprintf('Tests finished\n');

