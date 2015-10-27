% Cost and gradient for initializing a softmax classifier. Uses the given
% input features to classify for the given target classes, and computes the
% cross-entropy between the estimated and target distributions.

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


function [f, df] = softmaxInitCost(VV,Dim,feat,target)

% Some small values to avoid divide-by-zeros
SOFTMAX_EPS = 1e-6;
EPS2 = 1e-10;

numclasses = size(target,2);
N = size(feat,1);

% Weights for the regularization and misclassification penalties in the
% cost function
W_L1 = N*1e-8;
W_L2 = N*1e-6;
W_CLASS = 1;

l1 = Dim(1);
l2 = Dim(2);

% Convert the vector input from minFunc into a weight matrix
w_class = reshape(VV,l1+1,l2);

% Add a bias to input features
feat = [feat ones(N,1)];  

% Compute classification estimates
targetout = exp(feat*w_class);
targetout = targetout./repmat(sum(targetout,2)+SOFTMAX_EPS,1,numclasses);

% Compute L2-regularization cost and gradient
[l2Cost,l2Grad] = pNormGrad(w_class(1:end-1,:)',2);
l2Grad = l2Grad';

% Use a smoothed L1 penalty to avoid "ringing"
[l1Cost,l1Grad] = smoothedL1Cost(w_class(1:end-1,:));

% Compute total cost 
f = -sum(sum( target(:,1:end).*log(targetout+EPS2)))*W_CLASS ...
      + l2Cost*W_L2 + l1Cost*W_L1;

% Compute gradient for classification cost for the classifier weights
IO = (targetout-target(:,1:end))*W_CLASS;
Ix_class=IO; 
dw_class =  feat'*Ix_class + [l2Grad; zeros(1,size(w_class,2))]*W_L2 + [l1Grad; zeros(1,size(w_class,2))]*W_L1; 

% Convert gradient back into a vector for minFunc
df = dw_class(:); 