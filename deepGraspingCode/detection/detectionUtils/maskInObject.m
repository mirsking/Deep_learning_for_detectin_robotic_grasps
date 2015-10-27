% Compares the given foreground and background image, finds the largest
% blob that's significantly different from the background, and masks it,
% and a padded area around it in. Also returns the corners of the bounding
% box containing the entire masked-in area.
%
% Author: Ian Lenz

function [mask, bbCorners] = maskInObject(I, BG, padSz)

% How far in pixel distance the foreground has to be from the background to
% be considered different.
OFF_THRESH = 100;

% Buffer around the edges of the image, to avoid detecting hands/feet/etc.
% around the edges (since most objects are relatively centered, this
% shouldn't hurt anything).
BUF = 100;

mask = zeros(size(I,1),size(I,2));

% Don't buffer the bottom because some objects get close to/run off it
mask(BUF:end,BUF:end-BUF) = 1;

% Compute and threshold pixel distance
diff = sum(abs(I - BG),3);
diff = diff > OFF_THRESH;

diff = diff.*mask;

% Run blob detection
CC = bwconncomp(diff,8);

maxObj = -1;
maxSz = -1;

% Find the largest blob
for i = 1:CC.NumObjects
    curSz = length(CC.PixelIdxList{i});
    if curSz > maxSz
        maxObj = i;
        maxSz = curSz;
    end
end

% Mask in the largest blob, pad, and compute bounding box.
mask = zeros(size(I,1),size(I,2));

maskInd = CC.PixelIdxList{maxObj};

mask(maskInd) = 1;

padFil = ones(padSz*2 + 1);
mask = conv2(mask,padFil,'same') > 0;

[R,C] = ind2sub(size(mask),maskInd);
maskSub = [R C];

bbCorners = zeros(2,2);

bbCorners(1,:) = min(maskSub,[],1) - padSz;
bbCorners(2,:) = max(maskSub,[],1) + padSz;

