% Scales the given data by the given channel-wise standard deviations (or
% other channel-wise scaling factors). 
% 
% data is assumed to be an NxM matrix, where N is the number of cases, and
% M is the total number of features (in contrast to some other functions
% here, where M is the number of features per channel). stds is a K-vector
% of channel-wise scaling factors, which also tells us how many channels
% there are by its length.
%
% Author: Ian Lenz

function newDat = scaleDataByChannel(data,stds)

numChan = length(stds);

numCases = size(data,1);
featPerChan = size(data,2)/numChan;

nanChan = reshape(data,[numCases featPerChan numChan]);

newDat = scaleChannels(nanChan,stds);

newDat = reshape(newDat,numCases,featPerChan*numChan);
