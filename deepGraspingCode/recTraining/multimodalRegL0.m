% Cost and gradient for structured multimodal regularization, taking the L0
% of the max for each modality and feature (as approximated by log(1+x^2)
% and log-sum-exponential, respectively)
% 
% Modes is a vector indicating the mode of each feature. A value of 0 indicates
% that the feature shouldn't be considered for multimodal regularization
% (e.g. a bias)
%
% Author: Ian Lenz

function [cost,grad] = multimodalRegL0(W,modes,params)

numModes = max(modes(:));

cost = 0;
grad = zeros(size(W));

% Compute cost and gradient for each mode
for i = 1:numModes
    myW = W(:,modes == i);
    
    % Compute the cost and gradient for weights to this modality.
    [myCost,myGrad] = logSumExpL0Cost(myW,params.lseScale,params.lseEps,params.l0Scale);
    
    % Add it to the cost, and set the appropriate gradients for the full
    % weight matrix.
    cost = cost + myCost;
    grad(:,modes == i) = myGrad;
end


