% Given some data, its corresponding mask, and the number of channels,
% scales each channel by its standard deviation (accross all features in
% that channel).
% 
% Data is given as an NxM matrix, where N is the number of cases, and M is
% the total number of features (as opposed to the number of features per
% channel, as in some other files here). 
%
% numChan tells us how many channels the data has (7 for the grasping
% code). All channels are assumed to be the same size.
%
% Returns both the scaled data and the channel-wise standard deviations (in
% case we need to scale some other data.)
%
% Author: Ian Lenz

function [newDat,stds] = scaleDataByChannelStds(data,mask,numChan)

numCases = size(data,1);
featPerChan = size(data,2)/numChan;

data(~mask) = NaN;

nanChan = reshape(data,[numCases featPerChan numChan]);

stds = getChanStds(nanChan);

newDat = scaleChannels(nanChan,stds);
newDat(isnan(newDat)) = 0;

newDat = reshape(newDat,numCases,featPerChan*numChan);
