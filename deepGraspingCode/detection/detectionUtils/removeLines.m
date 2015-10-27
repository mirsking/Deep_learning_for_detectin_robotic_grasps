% Removes a set of lines from the current figure (given as a list of
% handles, so really could be anything with a handle to it).
%
% Author: Ian Lenz

function removeLines(h)

for i = 1:length(h)
    delete(h(i));
end