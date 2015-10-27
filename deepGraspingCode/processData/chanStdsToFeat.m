% Expands a set of channel-wise standard deviations to feature-wise
% standard deviations, given the edge size (in image space) for each
% channel (so if each channel is 24x24, chanSz would be given as 24)
%
% This is convenient pre-processing for whitening during detection.
%
% Author: Ian Lenz

function featStds = chanStdsToFeat(chanStds,chanSz)

numChan = length(chanStds);
featPerChan = chanSz^2;

chans = ceil((1:(featPerChan*numChan))/featPerChan);
featStds = chanStds(chans)';