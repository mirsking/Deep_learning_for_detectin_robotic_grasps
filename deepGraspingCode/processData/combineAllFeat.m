% Combines depth, color, and normal features into a single feature matrix
% for (pre-)training. Uses the same mask for the depth features and each of
% the normal channels.
%
% Author: Ian Lenz

function [feat,mask] = combineAllFeat(depthFeat, colorFeat, normFeat, depthMask, colorMask)

numDepth = size(depthFeat,2);
numColor = size(colorFeat,2);
numNorm = size(normFeat,2);

feat = zeros(size(depthFeat,1),numDepth + numColor + numNorm);
mask = zeros(size(feat));

feat(:,1:numDepth) = depthFeat;
mask(:,1:numDepth) = depthMask;

feat(:,numDepth+1:numDepth+numColor) = colorFeat;

% Repeat color mask for each channel (same for normals)
mask(:,numDepth+1:numDepth+numColor) = repmat(colorMask,1,3);

feat(:,numDepth+numColor+1:end) = normFeat;
mask(:,numDepth+numColor+1:end) = repmat(depthMask,1,3);