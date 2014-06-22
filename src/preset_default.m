% this is an example preset script, loading the default settings

clear;

% create a new object
sObj = SettingSingleton.instance();

sObj.setDwtWavelet('db1');
sObj.setDwtLevel(6);
sObj.setSubbandLength(8);
sObj.setEmbeddingStrengthFactor(1);
sObj.setBufferzoneScalingFactor(0.1);
sObj.setSynchronizationCode(13); % barker code 13
sObj.setBarkerThreshold(0.8);
sObj.setErrorCorrectionMethode('BCH');
sObj.setMessageLength(5);
sObj.setCodewordLength(15);
sObj.setConsiderODG(true);
