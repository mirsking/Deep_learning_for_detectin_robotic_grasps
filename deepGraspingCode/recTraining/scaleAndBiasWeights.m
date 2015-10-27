% Scale a given set of weights to give a target mean value for sigmoid
% output and a target standard deviation for input to the sigmoid (since
% it's expensive to invert the standard deviation of a sigmoid)
%
% Mean is scaled by setting the bias appropriately, standard deviation is
% scaled by multiplicatively scaling the weights.
%
% This is useful because SAE will often give features with good relative
% weight values, but may not give well-scaled features which use the full
% range of the sigmoid.
% 
% Author: Ian Lenz

function W = scaleAndBiasWeights(W, data, tgtStd, tgtMean)

% Find the target mean value for the input to the sigmoid (argument is
% assumed to be output, ie in the 0-1 range)
tgtXMean = inverseSigmoid(tgtMean);

% Compute output and standard deviation. Use this so scale weights
X = data * W;

Xstd = std(X);

W = bsxfun(@rdivide,W,Xstd/tgtStd);

% Re-compute outputs and use this to scale mean value
X = data * W;
meanX = mean(X);

bias = tgtXMean - meanX;

W = [W; bias];
