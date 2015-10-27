function [points,imPoints,rgb] = readGraspingPcd(fname)
% Read PCD data
% fname - Path to the PCD file
% data - Nx6 matrix where each row is a point, with fields x y z rgb imX imY. x, y, z are the 3D coordinates of the point, rgb is the color of the point packed into a float (unpack using unpackRGBFloat), imX and imY are the horizontal and vertical pixel locations of the point in the original Kinect image.
%
% Author: Kevin Lai

fid = fopen(fname,'rt');

isBinary = false;
nPts = 0;
nDims = -1;
line = [];
format = [];
headerLength = 0;
IS_NEW = true;
while length(line) < 4 | ~strcmp(line(1:4),'DATA')
   line = fgetl(fid);
   if ~ischar(line)
      % end of file reached before finished parsing. No data
      data = zeros(0,6);
      return;
   end

   headerLength = headerLength + length(line) + 1;

   if length(line) >= 4 && strcmp(line(1:4),'TYPE') %COLUMNS
      while ~isempty(line)
         [t line] = strtok(line);
         if nDims > -1 && strcmp(t,'F')
            format = [format '%f '];
         elseif nDims > -1 && strcmp(t,'U')
            format = [format '%d '];
         end
         nDims = nDims+1;
      end
   end      

   if length(line) >= 7 && strcmp(line(1:7),'COLUMNS')
      IS_NEW = false;
      while ~isempty(line)
         [ig line] = strtok(line);
         format = [format '%f '];
         nDims = nDims+1;
      end
   end

   if length(line) >= 6 && strcmp(line(1:6),'POINTS')
      [ig l2] = strtok(line);
      nPts = sscanf(l2,'%d');
   end

   if length(line) >= 4 && strcmp(line(1:4),'DATA')
      if length(line) == 11 && strcmp(line(6:11),'binary')
         isBinary = true;
      end
   end
end
format(end) = [];

if isBinary
   paddingLength = 4096*ceil(headerLength/4096);
   padding = fread(fid,paddingLength-headerLength,'uint8');
end

if isBinary && IS_NEW
   data = zeros(nPts,nDims);
   format = regexp(format,' ','split');
   for i=1:nPts
      for j=1:length(format)
         if strcmp(format{j},'%d') 
            pt = fread(fid,1,'uint32');
         else
            pt = fread(fid,1,'float');
         end
         data(i,j) = pt;
      end
   end
elseif isBinary && ~IS_NEW
   pts = fread(fid,inf,'float');
   data = zeros(nDims,nPts);
   data(:) = pts;
   data = data';
else
   format = [format '\n'];
   C = textscan(fid,format);

   points = cell2mat(C(1:3));
   rgb = unpackRGBFloat(C{4});
   imPoints = C{end};
end
fclose(fid);

