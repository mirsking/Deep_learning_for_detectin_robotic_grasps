% Whitens a split set of grasping data. This means doing case-wise
% whitening on the depth channel, then dropping feature-wise means and
% scaling per channel for all features.
%
% Author: Ian Lenz

% Since masks may be resized, need to re-convert them to binary by
% thresholding
MASK_THRESH = 0.75;

trainDepthMask = trainDepthMask > MASK_THRESH;
testDepthMask = testDepthMask > MASK_THRESH;

trainColorMask = trainColorMask > MASK_THRESH;
testColorMask = testColorMask > MASK_THRESH;

% Re-mask the depth data
trainDepthData = trainDepthData.*trainDepthMask;
testDepthData = testDepthData.*testDepthMask;

% First, drop depth means case-wise - necessary since distance to object
% might change
[trainDepthData,trainScale] = caseWiseWhiten(trainDepthData,trainDepthMask);
[testDepthData,testScale] = caseWiseWhiten(testDepthData,testDepthMask);

% Now, collect features
[trainData, trainMask] = combineAllFeat(trainDepthData,trainColorData,trainNormData,trainDepthMask,trainColorMask);
[testData, testMask] = combineAllFeat(testDepthData,testColorData,testNormData,testDepthMask,testColorMask);

trainData = trainData.*trainMask;
testData = testData.*testMask;

% Drop means by feature
[trainData, featMeans] = dropMeanByFeat(trainData,trainMask);
testData = bsxfun(@minus,testData,featMeans);
testData = testData.*testMask;

% Scale each channel by its standard deviation, preserving relative values
% within channels so that we don't exaggerate particular features, but
% giving each channel equal variance
[trainData, chanStds] = scaleDataByChannelStds(trainData,trainMask,7);
testData = scaleDataByChannel(testData,chanStds);