% Scales each channel by its corresponding standard deviation (or some
% other scaling value, that's just the way it's used here for whitening).
% 
% Assumes data is an NxMxK tensor, where N is the number of cases, M the
% number of features per channel, and K the number of channels. stds is
% then a K-vector.
%
% Author: Ian Lenz

function data = scaleChannels(data,stds)

numChan = length(stds);

for i = 1:numChan
    data(:,:,i) = data(:,:,i)/stds(i);
end