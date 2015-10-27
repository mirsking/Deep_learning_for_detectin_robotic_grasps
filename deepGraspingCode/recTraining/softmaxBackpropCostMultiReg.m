% Computes softmax classification error (as the cross-entropy between the
% estimated and target distributions) and a set of regularization
% penalties, along with their gradients for optimization.
%
% Back-propagates gradients through classifier weights and two hidden
% layers
% 
% Inputs:
% VV: vector of hidden layer and classifier weights, flattened for minFunc
% Dim: vector of hidden layer sizes
% XX: training data
% target: target output distribution (usually, just ground-truth classes)
% modes: modality index for each input feature

% GPU-enabled: if you don't add nogpu to MATLAB's path, matrices will be
% loaded onto the GPU. This can speed up computation, but might overload
% GPU memory
% Adding the nogpu directory to the path will turn GPU operations into
% no-ops, so everything will run on the CPU as normal

% Based on code provided by Ruslan Salakhutdinov and Geoff Hinton, which
% comes with the following notice:
%
% Permission is granted for anyone to copy, use, modify, or distribute this
% program and accompanying programs and documents for any purpose, provided
% this copyright notice is retained and prominently displayed, along with
% a note saying that the original programs are available from our
% web page.
% The programs and documents are distributed without any warranty, express or
% implied.  As the programs were written for research purposes only, they have
% not been tested to the degree that would be advisable in any important
% application.  All use of these programs is entirely at the user's own risk.
%
% Original Salakhutdinov/Hinton code available at: 
% http://www.cs.toronto.edu/~hinton/MatlabForSciencePaper.html


function [f, df] = softmaxBackpropCostMultiReg(VV,Dim,XX,target,modes)

N = size(XX,1);

% Weight for class error
CLASS_W = 1;

% Weight for class-weight L2 regularization
L2_REG_W = N*1e-6;

% Weight for L1 regularization of other weights
L1_REG_W = N*1e-6;

% Weight for multimodal sparsity
MULTI_W = N*1e-6;

% Numerical parameters for multimodal regularization
multiParams.lseScale = 300;
multiParams.lseEps = 0;
multiParams.l0Scale = 5e4;

numclasses = size(target,2);

% Hidden layer dimensions
l1 = Dim(1);
l2 = Dim(2);
l3= Dim(3);
l4= Dim(4);

target = gpuArray(target);

% Re-form weight matrices from parameter vector from minFunc
w1 = gpuArray(reshape(VV(1:(l1+1)*l2),l1+1,l2));
xxx = (l1+1)*l2;
w2 = gpuArray(reshape(VV(xxx+1:xxx+(l2+1)*l3),l2+1,l3));
xxx = xxx+(l2+1)*l3;
w_class = gpuArray(reshape(VV(xxx+1:xxx+(l3+1)*l4),l3+1,l4));

% Forward-propagate and compute softmax output
XX = gpuArray([XX ones(N,1)]);
w1probs = 1./(1 + exp(-XX*w1)); w1probs = [w1probs  ones(N,1)];
w2probs = 1./(1 + exp(-w1probs*w2)); w2probs = [w2probs ones(N,1)];

targetout = exp(w2probs*w_class);
targetout = targetout./repmat(sum(targetout,2),1,numclasses);

% Compute regularization penalties and gradients
[l2Cost,l2Grad] = pNormGrad(w_class(1:end-1,:)',2);

[w1L1Cost,w1L1Grad] = smoothedL1Cost(w1(1:end-1,:));
[w2L1Cost,w2L1Grad] = smoothedL1Cost(w2(1:end-1,:));

[multiCost, multiGrad] = multimodalRegL0(w1',modes,multiParams);
multiGrad = multiGrad';

f = gather(-sum(sum( target(:,1:end).*log(targetout)))*CLASS_W + l2Cost * L2_REG_W + ...
  (w1L1Cost + w2L1Cost)*L1_REG_W + MULTI_W * multiCost);

deriv1 = w1probs.*(1-w1probs);
deriv2 = w2probs.*(1-w2probs);

% Compute error gradient for classifier weights
IO = (targetout-target(:,1:end))*CLASS_W;
Ix_class=IO; 
dw_class =  w2probs'*Ix_class; 

% Back-propagate erorr gradient to second-layer hiddens
Ix2 = (Ix_class*w_class').*deriv2; 
Ix2 = Ix2(:,1:end-1);
dw2 =  w1probs'*Ix2;

% Back-propagate to first-layer hiddens
Ix1 = (Ix2*w2').*deriv1; 
Ix1 = Ix1(:,1:end-1);
dw1 =  XX'*Ix1;

% Add regularization to gradients and collect and flatten them for minFunc
dw1 = gather(dw1 + [w1L1Grad; zeros(1,size(w1,2))]*L1_REG_W + MULTI_W * multiGrad);
dw2 = gather(dw2 + [w2L1Grad; zeros(1,size(w2,2))]*L1_REG_W);
dw_class = gather(dw_class + [l2Grad'; zeros(1,size(w_class,2))]*L2_REG_W);

df = [dw1(:)' dw2(:)' dw_class(:)']'; 
