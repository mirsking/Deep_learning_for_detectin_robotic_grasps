% Cost function and gradients for sparse autoencoder (SAE) with L1 and
% multimodal regularization. Weights network input and reconstruction
% penalties based on the given mask, ignoring reconstruction for masked-out
% values.
%
% Author: Ian Lenz
% Partially adapted from code by Quoc Le

function [cost,grad] = sparseAECostMultiRegWeighted(theta, x, mask, modes, params)

N = size(x,2);

% unpack weight matrix
W = reshape(theta, params.numFeatures, params.n);

% Compute and scale regularization penalties
[l1Cost, l1Grad] = smoothedL1Cost(W(:,1:end-1));
l1Cost = l1Cost*params.l1Cost;
l1Grad = [l1Grad zeros(size(W,1),1)]*params.l1Cost;

[multiCost,multiGrad] = multimodalRegL0(W,modes,params);
multiCost = multiCost*params.multiCost;
multiGrad = multiGrad*params.multiCost;

% Scale inputs based on mask
xScaled = x.*mask;

% Forward propagation through autoencoder
h = 1./(1+exp(-W*xScaled));
r = W'*h;

% Sparsity cost (smoothed L1)
K = sqrt(params.epsilon + h.^2);
sparsity_cost = params.lambda * sum(sum(K));
K = 1./K;

% Compute reconstruction cost and back-propagate
% Mask out non-visible pixels - don't care about their recon
diff = (r - x);

reconstruction_cost = 0.5 * sum(sum(mask.*(diff.^2)));
outderv = diff.*mask;


% Sum up cost terms
% Scale up reg. terms based on # of training cases to keep them even with
% data-based costs
cost = sparsity_cost + reconstruction_cost + (l1Cost + multiCost)*N;

% Backprop output layer
W2grad = outderv * h';

% Backprop hidden Layer
outderv = W * outderv;
outderv = outderv + params.lambda * (h .* K);
outderv = outderv.* h .* (1-h);

W1grad = outderv * xScaled';
Wgrad = W1grad + W2grad' + (l1Grad + multiGrad)*N;

% Unproject gradient for minFunc
grad = Wgrad(:);
