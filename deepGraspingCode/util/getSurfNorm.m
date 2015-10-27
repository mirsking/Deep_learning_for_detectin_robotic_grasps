% Gets the surface normals for a given depth image. Normalizes them so
% the L2 norm for each point is 1 (MATLAB doesn't do this for us)
%
% Author: Ian Lenz

function N = getSurfNorm(D)

[Nx, Ny, Nz] = surfnorm(D);

N = zeros([size(Nx,1) size(Nx,2) 3]);
N(:,:,1) = Nx;
N(:,:,2) = Ny;
N(:,:,3) = Nz;

N = bsxfun(@rdivide,N,sqrt(sum(N.^2,3)));