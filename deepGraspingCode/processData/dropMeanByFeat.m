% Subtracts mean on a feature-wise basis.
%
% Author: Ian Lenz

function [feat,featMean] = dropMeanByFeat(feat,mask)

% Ignore masked-out values when computing the mean
feat(~mask) = NaN;

featMean = nanmean(feat,1);
feat = bsxfun(@minus,feat,featMean);

% Probably don't want NaNs in the final features, convert them back to 0's
feat(~mask) = 0;
