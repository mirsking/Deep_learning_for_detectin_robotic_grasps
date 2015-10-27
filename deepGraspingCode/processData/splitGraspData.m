% Splits a set of grasping data in the workspace into training and testing
% data, using a computed binary vector isTest which has one entry for each
% case, indicating whether or not that case should be sent to the test set.
%
% Author: Ian Lenz

% Split all the data based on isTest
trainDepthData = depthFeat(~isTest,:);
testDepthData = depthFeat(isTest,:);

trainColorData = colorFeat(~isTest,:);
testColorData = colorFeat(isTest,:);

trainNormData = normFeat(~isTest,:);
testNormData = normFeat(isTest,:);

trainDepthMask = depthMask(~isTest,:);
testDepthMask = depthMask(isTest,:);

trainColorMask = colorMask(~isTest,:);
testColorMask = colorMask(isTest,:);

trainClasses = classes(~isTest,:);
testClasses = classes(isTest,:);

% Clean up after ourselves to save some memory
clear depthData colorData normData depthMask colorMask classes;
