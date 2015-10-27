% Quick way to run a grasp search over an image. Runs a search for a
% default set of search parameters, loading some other necessary variables.
% 
% Takes the instance number to search for, the directory that the grasping
% data is in, and the directory that the background images are in.
%
% Assumes that the scripts in recTraining have been used to learn a set of
% weights, which are stored in ../weights
% 
% Arguments:
% instNum: instance number to do detection on
% dataDir: directory containing the grasping dataset cases (should have a
%          lot of pcd* files)
% bgDir: directory containing the dataset background files (pdcb*)
% 
% Author: Ian Lenz

function [bestRects,bestScores] = onePassDectionForInstDefaultParams(instNum,dataDir,bgDir)

load ../../data/bgNums.mat
load ../../data/graspModes24.mat
load ../../weights/graspWFinal.mat
load ../../data/graspWhtParams.mat

% Just use the positive-class weights for grasping.
w_class = w_class(:,1);

% Run detection with a default set of search parameters.
[bestRects,bestScores] = onePassDetectionForInst(dataDir,bgDir,bgNo,instNum,w1,w2,w_class,featMeans,featStds,0:15:(15*11),10:10:90,10:10:90,10,trainModes);