% Checks if one of the corners of the given axis-aligned rectangle
% (parameterized by upper-left corner and height/width) is masked out in
% the given mask
%
% Author: Ian Lenz

function maskedOut = cornerMaskedOut(mask,r,c,h,w)

maskedOut = ~mask(r,c) || ~mask(r+h,c) || ~mask(r+h,c+w) || ~mask(r,c+w);