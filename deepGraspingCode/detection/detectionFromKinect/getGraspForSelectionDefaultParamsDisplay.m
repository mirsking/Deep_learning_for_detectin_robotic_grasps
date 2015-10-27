% Gets a set of grasps for selected patches in the given input RGB image I,
% depth image D, and depth background DBG. Gives you a nice user-friendly
% interface.
%
% Uses a default set of search parameters to make things easy. 
%
% Visualizes the search as it runs. Shows the current rectangle (red/blue)
% and the top-ranked rectangle (yellow/green)
%
% Arguments:
% I: RGB foreground image (3 channels)
% D: depth foreground image (1 channel)
% DBG: depth background image (1 channel) 
%
% Author: Ian Lenz

function bestRects = getGraspForSelectionDefaultParamsDisplay(I,D,DBG)

load ../../data/bgNums.mat
load ../../data/graspModes24.mat
load ../../weights/graspWFinal.mat
load ../../data/graspWhtParams.mat

w_class = w_class(:,1);

bestRects = getGraspForSelectionDisplay(I,D,DBG,w1,w2,w_class,featMeans,featStds,0:15:(15*11),10:10:90,10:10:90,10,trainModes);