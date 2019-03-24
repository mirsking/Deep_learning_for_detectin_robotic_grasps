
dataDir = '../../data/';
bgDir = '../../data/backgrounds';
resDir = '../../data/result';
for index = 100:25:1034
    [bestRects,bestScores] = onePassDectionForInstDefaultParams(index,dataDir,bgDir);
    figure;
    imageName = sprintf('%s/pcd%04dr.png',dataDir,index);
    image = imread(imageName);
    [height, width, channel] = size(image);
    imshow(image);
    plotGraspRect(bestRects,'g','y');
    resName = sprintf('%s/pcd%04dr.png',resDir,index);
    saveas_center(gcf, resName, width, height);
    close all;
end

