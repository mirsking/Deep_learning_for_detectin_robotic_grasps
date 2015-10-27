% Performs simple whitening (subtract mean, divide by std) on a case-wise
% basis on the given features. Used for depth data, since we'd like each
% depth patch to be zero-mean, and scaled separately (so patches with a
% wider std. don't get more weight).
%
% Assumes these are all the same "type" of feature, so we can whiten them
% all together (use the same mean and std for all features).
%
% Author: Ian Lenz

function [feat,featStd] = caseWiseWhiten(feat,mask)

% Don't go below some minimum std. for whitening. This is to make sure that
% cases with low std's (flat table, etc.) don't get exaggerated too much,
% distorting appearance.
MINSTD = 10;

% Ignore masked-out values when computing means and stds
feat(~mask) = NaN;

featMean = nanmean(feat,2);
feat = bsxfun(@minus,feat,featMean);

featStd = max(nanstd(feat,0,2),MINSTD);
feat = bsxfun(@rdivide,feat,featStd);

% Probably don't want NaNs in the final features, convert them back to 0's
feat(~mask) = 0;
