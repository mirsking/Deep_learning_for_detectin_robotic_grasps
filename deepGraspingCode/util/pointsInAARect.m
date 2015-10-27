% Given an Nx2 matrix of 2D coordinates in imPoints, and a 4x2 list of
% rectangle corners in rectPoints, returns an Nx1 vector indicating whether
% each image point is inside the given rectangle.
%
% Author: Ian Lenz

function inRect = pointsInAARect(imPoints,rectPoints)

inRect = sign(imPoints(:,1) - rectPoints(1,1)) ~= sign(imPoints(:,1) - rectPoints(3,1))...
    & sign(imPoints(:,2) - rectPoints(1,2)) ~= sign(imPoints(:,2) - rectPoints(3,2));