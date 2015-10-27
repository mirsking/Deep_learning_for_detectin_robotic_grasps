

function [cost,grad] = dirtyRegCostL0(W,lseScale,lseEps,lseStepdown,l0Scale)

[absVal, absGrad] = smoothedAbs(W);
[abs0, ~] = smoothedAbs(0);

% Scale the log-sum-exponential to get a good approximation for lower
% W values - otherwise, doesn't correlate well to the max
curExp = exp(lseScale*absVal);

% To make results easier to interpret, subtract out the minimum value
% the log-sum-exponential can take from the cost, so the min cost is 0
%minVal = (size(W,2)/lseScale) * log(size(W,1) + lseEps);
minVal = log(exp(lseScale*abs0)*size(W,2) + lseEps)/lseScale;

% Include an extra constant value added to the sum of exponents to
% smooth near 0 (accounting for the absolute value op)
expSum = sum(curExp,2) + lseEps;

logSumExp = log(expSum)/lseScale - minVal;
l0Arg = 1+l0Scale*(logSumExp.^2);

rowGrad = (2*l0Scale*logSumExp)./(expSum.*l0Arg);

cost = sum(log(l0Arg));

% LSE derivative is just each individual exp value over the sum
grad = bsxfun(@times,curExp,rowGrad) .* absGrad;
