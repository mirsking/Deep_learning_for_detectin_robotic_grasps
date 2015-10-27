% converts rgb data to yuv  (FW-04-03)

function dst = rgb2yuv(src)

% ensure this runs with rgb images as well as rgb triples
if(length(size(src)) > 2)
    
    % rgb image ([r] [g] [b])
    r = double(src(:,:,1));
    g = double(src(:,:,2));
    b = double(src(:,:,3));
    
elseif(length(src) == 3)
    
    % rgb triplet ([r, g, b])
    r = double(src(1));
    g = double(src(2));
    b = double(src(3));
    
else
    
    % unknown input format
    error('rgb2yuv: unknown input format');
    
end
    
% convert...
y = 0.3*r + 0.5881*g + 0.1118*b;
u = -0.15*r - 0.2941*g + 0.3882*b;
v = 0.35*r - 0.2941*g - 0.0559*b;


% generate output
if(length(size(src)) > 2)
    
    % yuv image ([y] [u] [v])
    dst(:,:,1) = y;
    dst(:,:,2) = u;
    dst(:,:,3) = v;
    
else
    
    % yuv triplet ([y, u, v])
    dst = [y, u, v];
    
end
