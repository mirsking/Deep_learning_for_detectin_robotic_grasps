% Returns the fraction of the given mask which is masked-in for the
% rectangle with corner (r,c) and height/width h/w.
%
% Author: Ian Lenz

function frac = rectMaskFraction(mask,r,c,h,w)

curM = mask(r:r+h-1,c:c+w-1);

frac = sum(curM(:))/(w*h);