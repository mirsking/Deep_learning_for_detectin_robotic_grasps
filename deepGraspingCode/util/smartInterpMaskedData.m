% "Smart" interpolation of masked data.
%
% What this means is we do two passes - first, use linear interpolation to
% fill any points it can. Then, use nearest neighbors to fill in any points
% linear interpolation couldn't figure out.
%
% Author: Ian Lenz

function filled = smartInterpMaskedData(data,mask)

filled = interpMaskedData(data,mask,'linear');

mask2 = isnan(filled);

if(any(mask2(:)))
    filled = interpMaskedData(filled,~mask2,'nearest');
end