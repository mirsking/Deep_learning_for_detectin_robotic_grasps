% Partially adapted from code by Quoc Le
% 
% Pre-train second-layer weights using the sparse autoencoder (SAE)
% algorithm. Assumes the input features are in the 0-1 range (e.g the
% output of a previous hidden layer), and so uses a sigmoid to reconstruct 
% them. 
% 
% Takes input as trainFeat1, which is assumed to be the output from the
% first hidden layer
%
% If opttheta is present in your workspace, this script will continue
% optimizing from those values, otherwise it'll initialize weights to
% random values (so, be sure to clear it after training the first hidden
% layer)
%
% This code requires minFunc to run, but you can use the included cost
% functions with the optimizer of your choice. 
%
% The following should point to your location for minFunc:
addpath minFunc/

% Initialize some parameters based on the training data
global params;
params.m=size(trainFeat1,1);                 % number of training cases
params.n=size(trainFeat1,2)+1;   % dimensionality of input

% Switch this to toggle the use of a discriminative bias for training SAE.
% Sometimes, learning without a bias will give better features.
USE_BIAS = 1;

% Add bias to input data
x = [trainFeat1'; USE_BIAS*ones(1,size(trainFeat1,1))];

% Configure hyperparameters

% Number of features to learn
params.numFeatures = 200;

% Weight for the sparsity component of SAE
params.lambda = 3;

% Weight for an L1 penalty on weights
params.l1Cost = 3e-4;

% Numerical parameter, probably doesn't need to be changed
params.epsilon = 1e-5;

% Options for minFunc. L-BFGS typically gives the best results. 
% MaxIter sets the maximum number of learning iterations to use
options.Method = 'lbfgs';
options.MaxFunEvals = Inf;
options.MaxIter = 200;

% If there isn't a set of parameters in the workspace already, initialize
% them. If there are, we'll keep optimizing from them.
if ~exist('opttheta','var');
    % initialize with random weights
    randTheta = randn(params.numFeatures,params.n)*0.01;
    randTheta = l2rowscaled(randTheta,1);
    
    opttheta = randTheta(:);
    
    % This version will also include a generative bias since the features
    % aren't zero-mean. We optimize this even though we don't use it in the
    % final network (it helps in learning good features, since they don't
    % have to compensate for this).
    opttheta = [opttheta; zeros(params.n,1)];
    
    disp 'Initializing';
end

% Use minFunc to run optimization
[opttheta, cost, exitflag] = minFunc( @(theta) sparseAECostBinaryGenBias(theta, x, params), opttheta, options);   % Use x or xw 

% Reshape into a weight matrix for convenience
W = reshape(opttheta(1:params.numFeatures*params.n), params.numFeatures, params.n);