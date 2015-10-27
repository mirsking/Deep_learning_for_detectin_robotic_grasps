% Removes the background plane as given by depth background image BG from
% depth foreground image D. 
%
% Does this simply by averaging DBG across columns, and subtracting this
% row-wise average from each corresponding row of D. This lets us use
% different Kinect camera angles and still use a network trained with
% top-down data as in the dataset.
% 
% Author: Ian Lenz

function D = dropBGPlane(D,BG)

DMask = D~=0;

BGmean = mean(BG,2);
D = bsxfun(@minus,D,BGmean);

D = D.*DMask;