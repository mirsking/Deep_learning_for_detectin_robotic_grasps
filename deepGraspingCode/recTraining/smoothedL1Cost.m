% Cost and gradient for a smoothed L1 penalty on the weight matrix W. This
% means taking sqrt(w_{i,j}^2 + eps) for each weight w_{i,j}, and serves to
% solve numerical issues around zero by smoothing the penalty function.
% 
% Author: Ian Lenz
% Partially adapted from code by Quoc Le

function [cost,grad] = smoothedL1Cost(W)

EPS = 1e-7;

K = sqrt(EPS + W.^2);

cost = sum(K(:));
grad = W./K;