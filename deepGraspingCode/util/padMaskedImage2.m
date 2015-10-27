% Extends an image to the given dimensions. Scales so that at least one
% dimension will exactly match the target dimension.
% The other will either also match or be smaller, and be centered and padded 
% by zeros on either side.
%
% Author: Ian Lenz

function [I2, mask] = padMaskedImage2(I,mask,newR,newC)

% Compute ratios of the target/current dimensions
rRatio = newR/size(I,1);
cRatio = newC/size(I,2);

% Use these to figure out which dimension needs padding and resize
% accordingly, so that one dimension is "tight" to the new size
if rRatio < cRatio
    [I,Imask] = resizeMaskedImage2(I,mask,[newR NaN]);
else
    [I,Imask] = resizeMaskedImage2(I,mask,[NaN newC]);
end

% Place the resized image into the full-sized image
[numR, numC, numDims] = size(I);

rStart = round((newR-numR)/2) + 1;
cStart = round((newC-numC)/2) + 1;

I2 = zeros(newR,newC,numDims);

I2(rStart:rStart+numR-1,cStart:cStart+numC-1,:) = I;

% Also place the mask, masking out padding
mask = zeros(newR,newC,numDims);

mask(rStart:rStart+numR-1,cStart:cStart+numC-1,:) = Imask;