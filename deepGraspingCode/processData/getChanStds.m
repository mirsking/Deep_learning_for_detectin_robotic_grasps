% Compute the standard deviation for each channel in the given data. 
%
% The input, chanWithNans, is assumed to be formatted as follows:
% 
% NxMxK tensor, where N is the number of cases, M is the number of features
% per channel, and K is the number of channels.
% 
% NaN values for any masked-out data, so that we can use nanstd to ignore
% those values.
%
% Author: Ian Lenz

function stds = getChanStds(chanWithNans)

numChan = size(chanWithNans,3);

stds = zeros(numChan,1);

for i = 1:numChan
    curChan = chanWithNans(:,:,i);
    stds(i) = nanstd(curChan(:));
end