% Plot all rectangles in the Nx4x2 list of rectPts. Optionally also takes
% the color to plot the vertical and horizontal edges in, otherwise
% defaults to red/blue.
%
% Author: Ian Lenz

function plotAllDBNRects(rectPts,vertColor,horizColor)

if nargin < 2
    vertColor = 'r';
end

if nargin < 3
    horizColor = 'b';
end

numRects = size(rectPts,1);

startInd = 1;

for i = 1:numRects
    plotGraspRect(squeeze(rectPts(i,:,:)),vertColor,horizColor);
    startInd = startInd + 4;
end