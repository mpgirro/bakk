clear;

addpath('../');

% create a new object
sObj = SettingSingleton.instance();

% assign you desired settings
sObj.setDwtWavelet('db1');
sObj.setDwtLevel(6);
sObj.setSubbandLength(8);
sObj.setEmbeddingStrengthFactor(10);
sObj.setBufferzoneScalingFactor(0);
sObj.setSynchronizationCode(13); % barker code 13
sObj.setBarkerThreshold(0.8);
sObj.setErrorCorrectionMethode('BCH');
sObj.setMessageLength(5);

sObj.setCodewordLength(15);