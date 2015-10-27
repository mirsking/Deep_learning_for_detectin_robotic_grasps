% Sparse autoencoder cost for binary (sigmoidal) inputs. These are assumed
% to be in the 0-1 range, probably the outputs of a previous hidden layer. 
%
% Since these features will not be zero-mean, we also learn a generative
% bias for each, which is added to the input to the sigmoid that tries to
% reconstruct the feature. Even though these biases will not be used in the
% final network, learning them here improves the quality of the learned
% features.
% 
% Author: Ian Lenz

function [cost,grad] = sparseAECostBinaryGenBias(theta, x, params)

N = size(x,2);

% Unpack weights and gen. biases from parameters. Weights are the first
% part, gen. biases the second
W = reshape(theta(1:params.numFeatures*params.n), params.numFeatures, params.n);
genBias = theta(params.numFeatures*params.n+1:end);

% Compute and scale L1 regularization cost
[l1Cost, l1Grad] = smoothedL1Cost(W(:,1:end-1));
l1Cost = l1Cost*params.l1Cost;
l1Grad = [l1Grad zeros(size(W,1),1)]*params.l1Cost;

% Forward propagation through autoencoder
h = 1./(1+exp(-W*x));
r = 1./(1+exp(-(bsxfun(@plus,W'*h, genBias))));

% Sparsity cost (smoothed L1)
K = sqrt(params.epsilon + h.^2);
sparsity_cost = params.lambda * sum(sum(K));
K = 1./K;

% Compute reconstruction cost and back-propagate
diff = (r - x);

% Assume last term is bias - don't reconstruct it
diff(end,:) = 0;

reconstruction_cost = 0.5 * sum(sum(diff.^2));
outderv = diff.*r.*(1-r);

% Sum up cost terms
% Scale up reg. term based on # of training cases to keep them even with
% data-based costs
cost = sparsity_cost + reconstruction_cost + l1Cost*N;

% Backprop output layer
W2grad = outderv * h';
genBiasGrad = sum(outderv,2);

% Backprop hidden Layer
outderv = W * outderv;
outderv = outderv + params.lambda * (h .* K);
outderv = outderv.* h .* (1-h);

W1grad = outderv * x';
Wgrad = W1grad + W2grad' + l1Grad*N;

% Unproject gradient for minFunc
grad = [Wgrad(:); genBiasGrad(:)];
