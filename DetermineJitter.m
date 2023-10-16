function [sJitter] = DetermineJitter(nStims,rangeTime)

nJitter        = (max(rangeTime)-min(rangeTime))/(nStims-1); %yields the increment size required for length(sequence) trials
sJitter        = min(rangeTime):nJitter:max(rangeTime);

end