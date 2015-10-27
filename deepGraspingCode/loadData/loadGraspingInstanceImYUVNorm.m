% Loads features for all rectangles for a given image in the grasping
% rectangle dataset.
% 
% Inputs:
% dataDir: directory containing the dataset
%
% instNum: instance number to load
% 
% numR, numC: number of rows and cols for input features
%
% Outputs:
% *Feat: raw depth-, color-(YUV), and surface normal channel features as 
% flattened NUMR x NUMC images. Non-whitened
%
% class: graspability indicator for each case (1 indicates graspable)
% 
% inst: image that each case comes from
% 
% accepted: whether or not each rectangle was accepted. Rectangles may be
% rejected if not enough data was present inside the rectangle. This will
% contain more cases than the other outputs, since they won't contain
% rejected cases
% 
% depthMask: mask for the depth channel - masks out both areas outside the
% rectangle and points where Kinect failed to return a value. Also used for
% surface normal channels
%
% colorMask: similar, but only masks out areas outside the rectangle
%
% Author: Ian Lenz

function [depthFeat, colorFeat, normFeat, class, accepted, depthMask, colorMask] = loadGraspingInstanceImYUVNorm(dataDir,instNum,numR,numC)

addpath ../util

imArea = numR*numC;

I = graspPCDToRGBDImage(dataDir,instNum);

rectFilePos = sprintf('%s/pcd%04dcpos.txt',dataDir,instNum);
rectPointsPos = load(rectFilePos);
nRectPos = size(rectPointsPos,1)/4;

rectFileNeg = sprintf('%s/pcd%04dcneg.txt',dataDir,instNum);
rectPointsNeg = load(rectFileNeg);
nRectNeg = size(rectPointsNeg,1)/4;

depthFeat = zeros(0,imArea);
colorFeat = zeros(0,imArea*3);
normFeat = zeros(0,imArea*3);

depthMask = zeros(0,imArea);
colorMask = zeros(0,imArea);

class = zeros(0,1);
accepted = zeros(nRectPos + nRectNeg,1);

for i = 1:nRectPos
    startInd = (i-1)*4 + 1;
    curI = orientedRGBDRectangle(I,rectPointsPos(startInd:startInd+3,:));
    if size(curI,1) > 1
        [curI,D,N,IMask,DMask] = getNewFeatFromRGBD(curI(:,:,1:3),curI(:,:,4),ones(size(curI,1),size(curI,2)),numR,numC,0);
        depthFeat = [depthFeat; D(:)'];
        colorFeat = [colorFeat; curI(:)'];
        normFeat = [normFeat; N(:)'];
        colorMask = [colorMask; IMask(:)'];
        depthMask = [depthMask; DMask(:)'];
        class = [class; 1];
        accepted(i) = 1;
    end
end

for i = 1:nRectNeg
    startInd = (i-1)*4 + 1;
    curI = orientedRGBDRectangle(I,rectPointsNeg(startInd:startInd+3,:));
    if size(curI,1) > 1
        [curI,D,N,IMask,DMask] = getNewFeatFromRGBD(curI(:,:,1:3),curI(:,:,4),ones(size(curI,1),size(curI,2)),numR,numC,0);
        depthFeat = [depthFeat; D(:)'];
        colorFeat = [colorFeat; curI(:)'];
        normFeat = [normFeat; N(:)'];
        colorMask = [colorMask; IMask(:)'];
        depthMask = [depthMask; DMask(:)'];
        class = [class; 0];
        accepted(i + nRectPos) = 1;
    end
end
