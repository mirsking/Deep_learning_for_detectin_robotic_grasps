% Drops the mean from a depth patch, ignoring any values of 0 (which will
% be set back to 0 after mean is dropped)
% 
% Author: Ian Lenz

function D = dropDepthImMeanIgnoreZero(D)

mask = D ~= 0;

meanVal = mean(D(mask));

D = D - meanVal;
D(~mask) = 0;