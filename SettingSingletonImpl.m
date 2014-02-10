classdef SettingSingletonImpl < SettingSingleton

	properties % Public Access
%         dwt_wavelet;
%         dwt_level;
%         subband_length;
%         embedding_strength_factor;
	end

	methods(Access=private)
	   function newObj = SettingSingletonImpl()
           % Initialise properties.
           newObj.setDwtWavelet('db1');
           newObj.setDwtLevel(6); 
           newObj.setSubbandLength(8);
           newObj.setEmbeddingStrengthFactor(10);
	   end
	end

	methods(Static)
	   % Concrete implementation.  See Singleton superclass.
	   function obj = instance()
	      persistent uniqueInstance
	      if isempty(uniqueInstance)
	         obj = SettingSingletonImpl();
	         uniqueInstance = obj;
	      else
	         obj = uniqueInstance;
	      end
	   end
    end

end

