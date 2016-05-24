function changeBrightness
    dataDir = '../data';
    load([dataDir, '/bgNums.mat']);
    %% convert the background
    for i = 1:13
        bgFile = sprintf('%s/backgrounds/pcdb%04dr.png', dataDir, i);
        if ~exist(bgFile,'file')
            continue
        end
        img = imread(bgFile);
        changed_imgs = generateBrightnessImg(img);
        n = size(changed_imgs,1);
        for subi = 1:n
            newId = i+2000*subi;
            newImgFile = sprintf('%s/backgrounds/pcdb%04dr.png',dataDir,newId);
            newImg = reshape(changed_imgs(subi,:,:,:), size(img));
            imwrite(newImg, newImgFile);
        end
    end
    
    %% convert the data
    maxFile = 1100;
    for i = 1:maxFile
        pcdFile = sprintf('%s/pcd%04d.txt',dataDir,i);
        posRectFile = sprintf('%s/pcd%04dcpos.txt',dataDir,i);
        negRectFile = sprintf('%s/pcd%04dcneg.txt',dataDir,i);
        imgFile = sprintf('%s/pcd%04dr.png',dataDir,i);

        % Make sure the file exists (some gaps in the dataset)
        if ~exist(imgFile,'file')
            continue
        end

        fprintf(1,'Loading Image %04d\n',i);
        img = imread(imgFile);
        changed_imgs = generateBrightnessImg(img);
        n = size(changed_imgs,1);
        for subi = 1:n
            newId = i+2000*subi;
            newImgFile = sprintf('%s/pcd%04dr.png',dataDir,newId);
            newImg = reshape(changed_imgs(subi,:,:,:), size(img));
            imwrite(newImg, newImgFile);
            
            newPcdFile = sprintf('%s/pcd%04d.txt',dataDir,newId);
            copyfile(pcdFile, newPcdFile);
            newPosRectFile = sprintf('%s/pcd%04dcpos.txt',dataDir,newId);
            copyfile(posRectFile, newPosRectFile);
            newNegRectFile = sprintf('%s/pcd%04dcneg.txt',dataDir,newId);
            copyfile(negRectFile, newNegRectFile);
            
            bgNo(newId) = bgNo(i) + 2000*subi;
        end
    end
    
    %% save the bgNo
    save([dataDir, '/bgNums.mat'], 'bgNo');
end

function imgs = generateBrightnessImg(img)
    close all;
    scale = [0.5, 1.5];
    n = length(scale);

    hsv=rgb2hsv(img); 
    imgs = zeros([n, size(img)]);
    figure;
    for i=1:n
        hsv_tmp = hsv;
        hsv_tmp(:,:,3) = hsv_tmp(:,:,3).*scale(i);
        imgs(i,:,:,:) = hsv2rgb(hsv_tmp);
        subplot(n,2,(i-1)*2+1);imshow(img);
        subplot(n,2,(i-1)*2+2);imshow(reshape(imgs(i,:,:,:), size(img)));
        hold on;
    end

end