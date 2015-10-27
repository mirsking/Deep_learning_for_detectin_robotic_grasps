% Removes outliers for masked data. Returned data will be zero-mean
%
% Zeros out points with absolute value > stdCutoff * the std of the nonzero
% values in A, and updates the mask to reflect the removed points.
%
% Author: Ian Lenz

function [A,mask] = removeOutliers(A,mask,stdCutoff)

A(~mask) = NaN;
Amean = nanmean(A(:));
A = A - Amean;

Astd = nanstd(A(:));

mask(abs(A) > (stdCutoff * Astd)) = 0;

A(~mask) = NaN;
A = A - nanmean(A(:));
A(isnan(A)) = 0;