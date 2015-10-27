% Extract a patch from the given image corresponding to the given rectangle
% corners. Rectangle does not have to be axis-aligned.
%
% rectPoints is a 4x2 matrix, where each row is a point, and the columns
% represent the X and Y coordinates. The line segment from points 1 to 2
% corresponds to one of the gripper plates. 
%
% Author: Ian Lenz

function I2 = orientedRGBDRectangle(I,rectPoints)

SCALE = 1;

if any(isnan(rectPoints(:)))
    I2 = NaN;
    return;
end

% Compute the gripper angle based on the orientation from points 1 to 2
gripAng = atan2(rectPoints(1,2) - rectPoints(2,2),rectPoints(1,1)-rectPoints(2,1));

% Compute the X,Y coords for the image points, and rotate both them and the
% rectangle corners to be axis-aligned w/r/t the rectangle
[imX,imY] = meshgrid(1:size(I,2),1:size(I,1));
imPoints = [imX(:),imY(:)];

alignRot = rotMat2D(gripAng);

rectPointsRot = rectPoints * alignRot;
imPointsRot = imPoints * alignRot;

% Find the points from the image which are inside the rectangle. 
inRect = pointsInAARect(imPointsRot,rectPointsRot);

newPoints = imPointsRot(inRect,:);
newPoints = bsxfun(@minus,newPoints,min(newPoints));
newPoints = newPoints * SCALE + 1;

% Extract data corresponding to the points inside the rectangle
I2 = zeros(round(max(newPoints(:,2))),round(max(newPoints(:,1))),4);

newInd = sub2ind(size(I2(:,:,1)),round(newPoints(:,2)),round(newPoints(:,1)));

for i = 1:4
    channel = I(:,:,i);
    newChannel = zeros(size(I2,1),size(I2,2));
    newChannel(newInd) = channel(inRect);
    I2(:,:,i) = newChannel;
end

