% Returns a scaled version of the input mask, scaled up based on the
% masked-out fraction for each mode. 
%
% Author: Ian Lenz

function scaledMask = scaleMaskByModes2(mask,modes)

% Use some minimum scaling factor so we don't over-scale channels with a
% lot masked out.
MIN_SCALE = 0.6;

numModes = max(modes);

scaledMask = zeros(size(mask));

for mode = 1:numModes
    myMask = mask(:,modes == mode);
    
    maskRatios = max(mean(myMask,2),MIN_SCALE);
    
    scaledMask(:,modes == mode) = bsxfun(@rdivide,myMask,maskRatios);
end
