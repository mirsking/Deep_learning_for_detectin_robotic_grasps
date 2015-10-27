% Uses imSelectROI to prompt the user to select a rectangle in the given
% image I. Then, gives back patches corresponding to that rectangle from I
% and the depth image D and depth background image BG.
%
% Author: Ian Lenz

function [I, D, BG, rect] = selectRectInIm(I,D,BG)

rect = imSelectROI(I/255);

I = I(rect.Yrange,rect.Xrange,:);
D = D(rect.Yrange,rect.Xrange);
BG = BG(rect.Yrange,rect.Xrange,:);