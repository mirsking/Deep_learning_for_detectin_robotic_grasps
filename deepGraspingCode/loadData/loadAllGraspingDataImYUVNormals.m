% Load raw input features for the grasping rectangle data in the given
% directory.
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

function [depthFeat, colorFeat, normFeat, classes, inst, accepted, depthMask, colorMask]  = loadAllGraspingDataImYUVNormals(dataDir)

% Change these to change input size
NUMR = 24;
NUMC = 24;

maxFile = 1100;
imArea = NUMR*NUMC;

depthFeat = zeros(0,imArea);
colorFeat = zeros(0,imArea*3);
normFeat = zeros(0,imArea*3);

depthMask = zeros(0,imArea);
colorMask = zeros(0,imArea);

classes = false(0,1);
accepted = zeros(0,1);
inst = zeros(0,1);

for i = 1:maxFile
    pcdFile = sprintf('%s/pcd%04d.txt',dataDir,i);
    
    % Make sure the file exists (some gaps in the dataset)
    if ~exist(pcdFile,'file')
        continue
    end
        
    fprintf(1,'Loading PC %04d\n',i);
    
    % Read and store features
    [curDepth, curColor, curNorm, curClass, curAcc, curDMask, curIMask] = loadGraspingInstanceImYUVNorm(dataDir,i,NUMR,NUMC);
    
    depthFeat = [depthFeat; curDepth];
    colorFeat = [colorFeat; curColor];
    normFeat = [normFeat; curNorm];
    depthMask = [depthMask; curDMask];
    colorMask = [colorMask; curIMask];
    
    classes = [classes;curClass];
    accepted = [accepted;curAcc];
    inst = [inst;repmat(i,size(curClass,1),1)];
end
    
    
