% Takes in RGB, depth, and mask images, and generates a set of features of
% the given size (numR x numC)
%
% All generated features will be of this given dimension. Bounds are set by
% the mask, the other dimension will be padded so that the image is
% centered. All channels are scaled together
%
% Last argument just tells whether or not to flip the depth channel - for
% some data, depth numbers increase as they get further from us, for some
% it's the other way around, so this lets us choose
%
% Generates:
% I: color image converted to YUV color. Scaled into the [-1 1] range
% (although it'll probably get whitened later anyway)
%
% D: Depth image - to get this, we interpolate then downsample the given
% depth. We also drop the mean and filter out extreme outliers
%
% N: surface normals, 3 channels (X,Y,Z) - averaged from normals computed
% on the interpolated depth image
%
% IMask: Color image mask. Since we don't use the RGBD dataset mask for the
% color image, just masks out the padding needed to fit the target image
% size
%
% DMask: Mask for the depth and normal features. Based on the input mask,
% rescaled, with some additional outliers masked out
%
% Author: Ian Lenz

function [I,D,N,IMask,DMask] = getNewFeatFromRGBD(I1,D1,mask,numR,numC,negateDepth)

if nargin < 6
    negateDepth = 0;
end

if negateDepth
    D1 = -D1;
end

% Get rid of points where we don't have any depth values (probably points
% where Kinect couldn't get a value for some reason)
mask = mask.*(D1 ~= 0);

% Interpolate to get better data for downsampling/computing normals
D1 = D1.*mask;

% Do two passes of outlier removal since big outliers (as are present in
% some cases) can really skew the std, and leave other outliers well within
% the acceptable range. So, take these out and then recompute the std. If
% there aren't any huge outliers, std won't shift much and the 2nd pass
% won't eliminate that much more.
[D1,mask] = removeOutliers(D1,mask,4);
[D1,mask] = removeOutliers(D1,mask,4);
D1 = smartInterpMaskedData(D1,mask);

% Get normals from full-res image, then downsample
N = getSurfNorm(D1);
[N,~] = padImage(N,numR,numC);

% Downsample depth image and get new mask. 
[D,DMask] = padMaskedImage2(D1,mask,numR,numC);

I1 = rgb2yuv(I1);
[I,IMask] = padImage(I1,numR,numC);

% Re-range the YUV image. Just scale the Y channel to the [0,1] range.
% The version of yuv2rgb used here gives values in the [-128,128] range, so
% scale that to the [-1,1] range (but keep some values negative since this
% is more natural for the U and V components)
I(:,:,1) = I(:,:,1)/255;
I(:,:,2) = I(:,:,2)/128;
I(:,:,3) = I(:,:,3)/128;