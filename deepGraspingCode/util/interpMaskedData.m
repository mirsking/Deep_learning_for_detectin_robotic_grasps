% Interpolates masked data (e.g. the depth channel). Uses MATLAB's
% scattered interpolation functionality to do the interpolation, ignoring
% masked-out points.
%
% Can optionally provide the interpolation method to use, if not given,
% defaults to linear.
%
% Author: Ian Lenz

function filled = interpMaskedData(data, mask, method)

% Default method to linear if not provided
if nargin < 3
    method = 'linear';
end

% Don't do anything if everything is masked out
if ~any(mask(:))
    filled = data;
    return;
end

mask = logical(mask);

% Make a grid for X,Y coords, and pick the masked-in points
[X,Y] = meshgrid(1:size(data,2),1:size(data,1));

% Known points
Xg = X(mask);
Yg = Y(mask);

% "Query" points, to be filled
Xq = X(~mask);
Yq = Y(~mask);

Vg = data(mask);

% Run the interpolation, and read out the query points
F = TriScatteredInterp(Xg,Yg,Vg,method);
Vq = F(Xq,Yq);

% Initialize the returned data with the given data, and replace the
% masked-out points with their interpolated values.
filled = data;

if ~isempty(Vq)
    filled(~mask) = Vq;
end