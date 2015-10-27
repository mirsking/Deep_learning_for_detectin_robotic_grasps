% Masks in points where the foreground image is more than some threshold
% off of the background image, then pads with the given padding range.
% 
% Author: Ian Lenz

function mask = getForegroundMask(I, BG, thresh, pad)

off = sum(abs(I - BG),3);
mask = off > thresh;

padFil = ones(pad*2+1,pad*2+1);

mask = conv2(double(mask),padFil,'same') > 0;