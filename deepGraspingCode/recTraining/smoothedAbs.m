% Computes the smoothed absolute value for each value in W. This is
% sqrt(w_{i,j}^2 + eps) for each weight, and serves to solve numerical 
% issues around zero.
%
% Author: Ian Lenz
% Partially adapted from code by Quoc Le

function [val,grad] = smoothedAbs(W)

EPS = 1e-7;

val = sqrt(W.^2 + EPS);

grad = W./val;
