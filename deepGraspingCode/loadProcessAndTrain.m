% Set this to the path to your folder containing the Cornell Grasping
% Dataset (this folder should contain a lot of pcd_* files)
dataDir = '~/data/rawDataSet';

% Load the grasping dataset
cd loadData/
[depthFeat, colorFeat, normFeat, classes, inst, accepted, depthMask, colorMask]  = loadAllGraspingDataImYUVNormals('~/data/rawDataSet');
classes = logical(classes);

% Process data, splitting into train/test sets and whitening
cd ../processData/
processGraspData

cd ../recTraining/
trainGraspRecMultiSparse

cd ../

% Workspace will be pretty messy here, but I don't like putting a clear all
% in this script, since you might have your own stuff there that you don't
% want to lose.