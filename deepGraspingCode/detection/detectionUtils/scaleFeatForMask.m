% Scales a set of input features based on how much of their mask is
% masked-out for each channel.
%
% Author: Ian Lenz

function feat = scaleFeatForMask(feat,mask,modes)

mask = scaleMaskByModes2(mask,modes);

feat = feat.*mask;