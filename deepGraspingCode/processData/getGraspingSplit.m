% Randomly split grasping data with the given ratio for test data
% Be a little smart and split positive and negative cases separately so the
% train and test sets will have the same ratio.
%
% Author: Ian Lenz

function isTest = getGraspingSplit(classes,ratio)

numPos = sum(classes);

isTest = zeros(size(classes));

posSamples = randsample(numPos,round(numPos*ratio));

posIsTest = zeros(numPos,1);
posIsTest(posSamples) = 1;

isTest(classes) = posIsTest;

classNeg = ~classes;
numNeg = sum(classNeg);

negSamples = randsample(numNeg,round(numNeg*ratio));

negIsTest = zeros(numNeg,1);
negIsTest(negSamples) = 1;

isTest(classNeg) = negIsTest;