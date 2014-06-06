function [ newSignal, resync_success ] = resynchronize( oldSignal )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% so boys, this is where it gets compicated
% first we need to try all the different segment
% lengths and look if there is a sync code embedded
% if we found one, we will interpolate the signal
% to a new one

resync_success = int8(0);

fprintf('Starting resynchronisation...');

originalFrameLength = Setting.frame_length;
stepLength = floor(originalFrameLength * 0.005); % we will change the framelength in 0.5% steps
lowerBound = floor(originalFrameLength - 0.1 * originalFrameLength);
upperBound = floor(originalFrameLength + 0.1 * originalFrameLength);

signalSize = size(oldSignal);
signalSize = signalSize(1);

alpha = 0;

%for signalCursor=1:floor(lowerBound*0.1):signalSize-upperBound
%    for tmpFrameLength=lowerBound:stepLength:upperBound
signalCursor = 1;
while signalCursor < signalSize-upperBound
    
    tmpFrameLength = lowerBound;
    
    while tmpFrameLength < upperBound
        
        % this is the frame we test with
        testSignal = oldSignal(signalCursor:signalSize);
        
        % check this frame for a sync code
        sync_found = synccodedetector( testSignal, tmpFrameLength );
        
        if sync_found
            % checkpod!
            % now do what we are here todo
            resync_success = 1;
            
            if tmpFrameLength < originalFrameLength
                % this line should always be executed
                % but it seems we sometimes have the other case
                alpha = tmpFrameLength / originalFrameLength;
            else
                alpha = originalFrameLength / tmpFrameLength;
            end
                
                
            % preallocate the size for the new signal
            newSignal = zeros([signalSize 1]);
  
            newSignal(1) = oldSignal(1);
            %for i=2:signalSize-1
            for i=2:numel(oldSignal)-1
                beta = alpha*i - floor(alpha*i);
                newSignal(i) = (1-beta)*oldSignal(floor(alpha*i)) + beta*oldSignal(floor(alpha*i)+1);
            end
            newSignal(signalSize) = oldSignal(signalSize);
            
            break;
        else
            % meh...resume
            tmpFrameLength = tmpFrameLength + stepLength;
        end
    end
    
    if resync_success == 1
        % very good, the signal is reinterpolated and we can go home
        break;
    else
        % meh...move signal cursor and try all over again
        signalCursor = signalCursor + floor(lowerBound*0.1);
    end
end


if resync_success == 1
    fprintf('SUCCESS\n\tSignal was interpolated with alpha=%f\n',alpha);
else
    fprintf('FAILED\n\tNow watermark you be found\n');
    newSignal = oldSignal; % we need to return something...
end

end



