% Inverse of the sigmoid function
% 
% Author: Ian Lenz

function x = inverseSigmoid(y)

x = -log(1/y - 1);