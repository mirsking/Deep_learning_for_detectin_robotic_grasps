% Processes grasping data from the workspace. Splits it into training and
% testing sets, and whitens appropriately. Saves both the split, whitened
% data and the parameters used for whitening. The later is necessary for
% detection, where we need to whiten the data in the same way we did when
% training for recognition.
%
% Author: Ian Lenz

addpath ../util

% For some purposes, it's useful to have both of these
classes = [classes ~classes];

% Split data into training and testing sets
isTest = logical(getGraspingSplit(classes(:,1),0.2));
splitGraspData;

% Uncomment to save unwhitened split data:
% save -v7.3 /localdisk/data/graspNewerSplit;

% Whiten the data (critical for deep learning to work)
whitenDataCaseWiseDepth;

% Save the training and testing data to separate files
save -v7.3 ../data/graspTrainData trainData trainMask trainClasses;
save -v7.3 ../data/graspTestData testData testMask testClasses;

% Save the parameters used for whitening - these will be used for detection
featStds = chanStdsToFeat(chanStds,sqrt(size(trainData,2)/7));
save -v7.3 ../data/graspWhtParams featMeans featStds;
