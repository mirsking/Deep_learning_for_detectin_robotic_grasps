% Makes the masked-out area of the given image "white" (really, sets all
% channels to whatever value BGVAL specifies, slightly off-white
% corresponds well to the grasping dataset). This lets us work with
% different background colors and still have data matching the dataset
% closely.
%
% Author: Ian Lenz

function I = makeBGWhite(I,mask)

BGVAL = 230;

I = bsxfun(@times,I,mask);
I = bsxfun(@plus,I,(~mask)*BGVAL);