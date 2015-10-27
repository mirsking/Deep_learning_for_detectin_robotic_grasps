% Resize an image which includes a mask. This doesn't change the process of
% resizing the image (we assume it's already been interpolated to fill in
% missing data), but we do have to figure out the resized mask as well.
% 
% Do this by checking how much weight the interpolation gives to the good
% data vs the missing data by resizing the mask and checking it against a
% threshold.
%
% Author: Ian Lenz

function [D, mask] = resizeMaskedImage2(D, mask, newSz)

D = imresize(D,newSz);

mask = imresize(double(mask),newSz);
