% Partially adapted from code by Quoc Le
% 
% Pre-train first-layer weights using the sparse autoencoder (SAE)
% algorithm, with a structured multimodal regularization penalty. Assumes
% the following variables are present in the workspace:
%
% trainData: matrix of training data, where each row represents a case and
% each column represents a feature
% 
% trainMask: mask for the training data, same size as trainData
% A 0 indicates a masked-out value and 1 is masked-in. Reconstruction 
% penalties will not be considered for masked-out values. Mask is also used
% to scale input values and their reconstruction penalties
%
% trainModes: vector indicating the modality which each feature belongs to
% 
% All of these are prefixed by "train" so you can run:
% clearvars -except train*
% to clean up after this script if you want to re-run training
%
% If opttheta is present in your workspace, this script will continue
% optimizing from those values, otherwise it'll initialize weights to
% random values
%
% This code requires minFunc to run, but you can use the included cost
% functions with the optimizer of your choice. 
%
% The following should point to your location for minFunc:
addpath ../minFunc/

% Switch this to toggle the use of a discriminative bias for training SAE.
% Sometimes, learning without a bias will give better features.
USE_BIAS = 0;

% Initialize some parameters based on the training data
global params;
params.m=size(trainData,1);     % number of training cases
params.n=size(trainData,2)+1;   % dimensionality of input (+1 for bias)

% Scale the training mask based on fraction of masked-out values
scaledMask = scaleMaskByModes2(trainMask,trainModes);

% Add bias to training data
x = [trainData'; USE_BIAS*ones(1,size(trainData,1))];
mask = [scaledMask'; zeros(1,size(trainData,1))];
modes = [trainModes 0];

% Configure hyperparameters

% Number of features to learn
params.numFeatures = 200;

% Weight for the sparsity component of SAE
params.lambda = 3;

% Weight for an L1 penalty on weights
params.l1Cost = 3e-4;

% Weight for the structured multimodal regularization
params.multiCost = 0.01;

% Parameters for numerical approximations
params.epsilon = 1e-5;
params.lseScale = 200;
params.lseEps = 0;
params.lseStepdown = 1;
params.l0Scale = 1e15;
params.nonDG = 0;

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
    disp 'Initializing';
end

% Use minFunc to run optimization
[opttheta, cost, exitflag] = minFunc( @(theta) sparseAECostMultiRegWeighted(theta, x, mask, modes, params), opttheta, options);

% Reshape into a weight matrix for convenience
W = reshape(opttheta, params.numFeatures, params.n);


