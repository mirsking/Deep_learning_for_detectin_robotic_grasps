% Loads the given instance number from the given directory (containing the
% grasping dataset), and returns the RGB-D data as a 4-channel image, with
% RGB as channels 1-3 and D as channel 4.
%
% Author: Ian Lenz

function I = graspPCDToRGBDImage(dataDir, fileNum)

pcdFile = sprintf('%s/pcd%04d.txt',dataDir,fileNum);
imFile = sprintf('%s/pcd%04dr.png',dataDir,fileNum);

[points, imPoints] = readGraspingPcd(pcdFile);

I = double(imread(imFile));
D = zeros(size(I,2),size(I,1));
D(imPoints) = points(:,3);

I(:,:,4) = D';