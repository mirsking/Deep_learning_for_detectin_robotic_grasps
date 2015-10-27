% Translates a set of points from an oriented, cropped image to global
% image space, given a mapping between the two.
%
% Author: Ian Lenz

function imPoints = localRectToImGivenMap(rectPoints,R,C,bbCorners)

imPoints = zeros(size(rectPoints));

for i = 1:size(rectPoints,1)
    imPoints(i,1) = R(rectPoints(i,1),rectPoints(i,2));
    imPoints(i,2) = C(rectPoints(i,1),rectPoints(i,2));
end

imPoints(:,1) = imPoints(:,1) + bbCorners(1,1);
imPoints(:,2) = imPoints(:,2) + bbCorners(1,2);