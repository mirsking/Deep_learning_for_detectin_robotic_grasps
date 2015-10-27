% Computes the p-norm across the 2nd dim of W and its grad w/r/t each
% element of W.
% 
% Author: Ian Lenz

function [cost,grad] = pNormGrad(W,p)

% Epsilon-smooth near 0
EPS = 1e-6;

sumPow = sum(abs(W).^p,2) + EPS;

cost = sum(sumPow.^(1/p));

grad = bsxfun(@times,abs(W).^(p-1),sumPow.^(1/p - 1));
grad = grad.*sign(W);