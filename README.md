# Digital audio-watermarking for analog communication channels

## What is this?

This is the code and thesis of my bachelor project I wrote in 2013/2014 at TU Wien. It is about the implementation of an audio watermarking algorithm aimed for analog communication channels and its utilisation in an application framework.

If you want to cite the original thesis (german language), you can use the following [BibTeX entry](http://max.irro.at/pub/bakk.bib):

```
@mastersthesis{Irro2014,
  document_type     = {Bachelor's Thesis},
  author            = {Maximilian Irro},
  title             = {Digital Audio-Watermarking für analoge Übertragungsstrecken},
  school            = {TU Wien},
  type              = {Bachelor Thesis},
  year              = {2014},
  month             = {June},
  keywords          = {audio, watermarking},
  timestamp         = {20140623},
  url               = {http://max.irro.at/pub/bakk/index.html},
  pdf               = {http://max.irro.at/pub/bakk/thesis.pdf}
}
```

## Abstract

While digital audio watermarking is already a widespread practice, most research only concern copyright protection mechanisms. An aim on open information integration is hardly ever a focus of development goals. Yet there are use cases were additional information in audio signals would be of most value. Especially digital/analog (DA) conversion processes tend to lose all sorts of metadata, for them not being translated into acoustic signals. This is where watermarks may come to aid. Also they could be utilized to add additional information to radio and TV broadcast which would make them accessible not only to the receiving device.

This paper describes the implementations of an existing watermarking algorithm claiming to be capable of enduring DA conversions. Additionally a framework is proposed to utilize the algorithm in a developed communication protocol with synchronization-codes and error-correction mechanisms to provide a well defined, stable communication channel.

## Usage

The projects is a prototypical MATLAB implementation. There are basically two functions to use:

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

### Change Settings

To change the default settings, use SettingSingleton object. 

	sObj = SettingSingleton.instance();  
	sObj.setDwtWavelet(’db2’);  
	sObj.setDwtLevel(8);  
	sObj.setSubbandLength(10);  
	% etc...

Those alterations are best done by utilising a *preset* script and **have to** be executed **before** every run of encoder/decoder.
