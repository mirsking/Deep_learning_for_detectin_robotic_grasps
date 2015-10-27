function rgb = unpackRGBFloat(rgbfloatdata)
% Unpack RGB float data into separate color values
% rgbfloatdata - the RGB data packed into Nx1 floats
% rgb - Nx3 unpacked RGB values
%
% Author: Kevin Lai

mask = hex2dec('000000FF');
rgb = typecast(rgbfloatdata,'uint32');

r = uint8(bitand(bitshift(rgb,-16),mask));
g = uint8(bitand(bitshift(rgb,-8),mask));
b = uint8(bitand(rgb,mask));
rgb = [r g b];

