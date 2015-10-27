% Gets a series of grasping rectangles for the given image I, depth image
% D, and background depth image (without any objects) BG.
%
% w's are the DBN weights. Currently hard-coded for two layers, with a
% linear scoring layer on top
%
% means and stds are used to whiten the data. These should be the same
% whitening parameters used for the training data
%
% rotAngs, hts, and wds are vectors of candidate rotations, heights, and
% widths to consider for grasping rectangles. Only rectangles with width >=
% height will be considered.
%
% scanStep determines the step size when sweeping the rectangles across
% image space
%
% User-friendly! Will prompt you each time to ask if you want to run
% another search, and gives you the option to keep or discard the rectangle
% after each time it runs a search. Will keep track of all kept rectangles,
% so the output will be Kx4x2, where K is the number of rectangles kept.
% 
% Visualizes the search as it runs. Shows the current rectangle (red/blue)
% and the top-ranked rectangle (yellow/green)
%
% Author: Ian Lenz

function bestRects = getGraspForSelectionDisplay(I,D,BG,w1,w2,wClass,means,stds,rotAngs,hts,wds,scanStep,modes)

addpath ../detectionUtils/
addpath ../../util/

MASK_THRESH = 10;
MASK_PAD = 4;
SIGN = -1;
SCALE_ADJ = 1;

% Convert images and display color image
I = double(I);
D = double(D)/SCALE_ADJ;
BG = double(BG)/SCALE_ADJ;

bestRects = zeros(0,4,2);

i = 1;

figure(1);
imshow(I/255);

while true
    
    % Prompt if the user wants to get another grasp.
    fprintf(1,'Another?\n');
    k = getkey;
    
    if k ~= 'y'
        break;
    end

    % Select the area to search in, and mask out the background
    [I1,D1,BG1,rect] = selectRectInIm(I,D,BG);

    mask = getForegroundMask(D1,BG1,MASK_THRESH,MASK_PAD);
    
    % Drop the slant of the background plane (tabletop) from the depth
    % image. This lets us work at different mounting angles, even though
    % the dataset is mostly overhead images.
    D1 = dropBGPlane(D1,BG1);
    
    D1 = SIGN*D1;

    % Make areas not on the object in question white (really, light grey)
    % to correspond better to the data and make the object stand out
    % better.
    I1 = makeBGWhite(I1,mask);
    
    % Run detection and shift the rectangle (detected in the selected
    % patch's coords) back to full-image coords
    figure(2);
    myBest = onePassDetectionNormDisplayFromIm(I1,D1,ones(size(D1)),w1,w2,wClass,means,stds,rotAngs,hts,wds,scanStep,modes);
    close;
    
    myBest(:,1) = myBest(:,1) + rect.Ymin;
    myBest(:,2) = myBest(:,2) + rect.Xmin;
    
    % Plot the rectangle and ask if the user wants to keep it. If they do,
    % add it to the list and switch colors. If not, just remove it.
    figure(1);
    lineH = plotGraspRect(myBest);
    
    fprintf(1,'Keep?');
    k = getkey;
    
    removeLines(lineH);
    
    if k == 'y'
        plotGraspRect(myBest,'g','y');
        bestRects(i,:,:) = myBest;
        i = i + 1;
    end
    
    i = i + 1;
end