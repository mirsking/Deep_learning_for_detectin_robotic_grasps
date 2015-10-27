% Simple data whitening - just subtract the given feature-wise means, then
% divide by the given feature-wise standard deviations.
%
% Author: Ian Lenz

function feat = simpleWhiten(feat,means,stds)

mask = feat ~= 0;

feat = bsxfun(@minus,feat,means);
feat = bsxfun(@rdivide,feat,stds);

feat = feat.*mask;