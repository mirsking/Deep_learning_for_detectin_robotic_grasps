function scaledMask = scaleMaskByModes2(mask,modes)

MIN_SCALE = 0.6;

numModes = max(modes);

scaledMask = zeros(size(mask));

for mode = 1:numModes
    myMask = mask(:,modes == mode);
    
    maskRatios = max(mean(myMask,2),MIN_SCALE);
    
    scaledMask(:,modes == mode) = bsxfun(@rdivide,myMask,maskRatios);
end

%scaledMask = bsxfun(@times,scaledMask,size(scaledMask,2)./sum(scaledMask,2));
