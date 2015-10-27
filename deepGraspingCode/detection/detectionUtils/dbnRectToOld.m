% Converts a rectangle from the format used by the deep learning code to
% the form used by the old Jiang grasping code.
%
% Author: Ian Lenz

function fixedRect = dbnRectToOld(dbnRect)

dbnRect = fliplr(dbnRect);

fixedRect = dbnRect;
fixedRect(2,:) = dbnRect(4,:);
fixedRect(4,:) = dbnRect(2,:);