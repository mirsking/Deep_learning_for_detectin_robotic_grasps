% Makes a 2D rotation matrix correspoing to the given angle in radians.
% Imagine that.
%
% Author: Ian Lenz

function R = rotMat2D(ang)

R = [cos(ang) -sin(ang); sin(ang) cos(ang)];