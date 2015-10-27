% Computes an approximation to the L0 of the row-wise max for a set of
% weights W. Uses the log-sum-exponential to approximate the max, and
% log(1+x^2) to approximate L0.
%
% Author: Ian Lenz

function [cost,grad] = logSumExpL0Cost(W,lseScale,lseEps,l0Scale)

% Use a smoothed absolute value. Compute the same for 0 so we can subtract
% out the min. value, which is important for taking L0
[absVal, absGrad] = smoothedAbs(W);
[abs0, ~] = smoothedAbs(0);

% Scale the log-sum-exponential to get a good approximation for lower
% W values - otherwise, doesn't correlate well to the max
curExp = exp(lseScale*absVal);

% For the L0 part, we need the min value of the LSE part to actually be 0.
% Compute the actual minimum and subtract it out (later)
minVal = log(exp(lseScale*abs0)*size(W,2) + lseEps)/lseScale;

% Include an extra constant value added to the sum of exponents to
% smooth near 0
expSum = sum(curExp,2) + lseEps;

% Compute some useful values for computing cost & gradients
logSumExp = log(expSum)/lseScale - minVal;
l0Arg = 1+l0Scale*(logSumExp.^2);

% Gradient for each value is the exponential part times this value for the
% appropriate row:
rowGrad = (2*l0Scale*logSumExp)./(expSum.*l0Arg);

cost = sum(log(l0Arg));

grad = bsxfun(@times,curExp,rowGrad) .* absGrad;
