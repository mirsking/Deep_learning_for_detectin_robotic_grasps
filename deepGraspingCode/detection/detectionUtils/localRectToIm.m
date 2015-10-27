% Translates a set of points from an oriented, cropped image to global
% image space.
%
% Author: Ian Lenz

function imPoints = localRectToIm(rectPoints,rotAng,bbCorners)

bbW = bbCorners(2,2) - bbCorners(1,2) + 1;
bbH = bbCorners(2,1) - bbCorners(1,1) + 1;

R = repmat((1:bbH)',1,bbW);
C = repmat(1:bbW,bbH,1);

R = imrotate(R,rotAng);
C = imrotate(C,rotAng);

imPoints = zeros(size(rectPoints));

for i = 1:size(rectPoints,1)
    imPoints(i,1) = R(rectPoints(i,1),rectPoints(i,2));
    imPoints(i,2) = C(rectPoints(i,1),rectPoints(i,2));
end

imPoints(:,1) = imPoints(:,1) + bbCorners(1,1);
imPoints(:,2) = imPoints(:,2) + bbCorners(1,2);