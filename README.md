# Bachelor's Project

**Digital audio-watermarking for analog communication channels** by Maximilian Irro

This is the code of my bachelor's project. It is about the implementation of an audio watermarking algorithm aimed for analog communication channels and its utilisation in an application framework. Detailed explination is available in the thesis report at [maximilian.irro.at/bsc](http://maximilian.irro.at/bsc).

## Usage

There are basically two functions to use:

### encoder

The encoder module is dead simple. Give it a digital signal (= a sample sequence), the data you want to encode and the sampling frequency of the signal and it will give you the samples of the modified signal.

	data = randi([0 1], 1, 100);  
	[signal,fs] = audioread(’test.wav’);  
	[modSignal, count] = encoder(signal, data, fs);  
	audiowrite(’result.wav’,modSignal, fs);
	
### decoder 

The decoder module is even simpler. Give it a watermarked signal and it's sampling frequency and it will give you the encoded bits.

	[signal,fs] = audioread(’result.wav’);  
	data = decoder(signal,fs);
	
## Change Settings

To change the default settings, use SettingSingleton object. 

	sObj = SettingSingleton.instance();  
	sObj.setDwtWavelet(’db2’);  
	sObj.setDwtLevel(8);  
	sObj.setSubbandLength(10);  
	% etc...
	
Those alterations are best done by utilising a *preset* script and **have to** be executed **before** every run of encoder/decoder.
