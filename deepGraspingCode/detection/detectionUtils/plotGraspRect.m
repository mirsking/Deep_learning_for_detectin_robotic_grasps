% Plots a grasping rectangle over the current image, given a 4x2 matrix of
% points. Optionally also takes the color to plot the vertical and 
% horizontal edges in, otherwise defaults to red/blue.
%
% Returns a list of handles to the plotted lines, in case we need to remove
% them from the image later.
%
% Author: Ian Lenz

function h = plotGraspRect(rectPts,vertColor,horizColor)

if nargin < 2
    vertColor = 'r';
end

if nargin < 3
    horizColor = 'b';
end

hold on;
h(1) = line([rectPts(1,2) rectPts(2,2)],[rectPts(1,1) rectPts(2,1)],'Color',vertColor);
h(2) = line([rectPts(3,2) rectPts(4,2)],[rectPts(3,1) rectPts(4,1)],'Color',vertColor);
h(3) = line([rectPts(2,2) rectPts(3,2)],[rectPts(2,1) rectPts(3,1)],'Color',horizColor);
h(4) = line([rectPts(1,2) rectPts(4,2)],[rectPts(1,1) rectPts(4,1)],'Color',horizColor);
hold off