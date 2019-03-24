%% visulize the trained feature
function featureVisulizer(w1, featMeans, featStds)

    param.m = size(w1, 1)-1;% remove the bias
    param.n = size(w1, 2);

    x = zeros(param.m,param.n);

    for j=1:param.n
        sqrt_sum = sqrt( sum( w1(:,j).^2 ) );
        for i=1:param.m
            x(i,j) = w1(i,j)/sqrt_sum;
%             x(i,j) = x(i,j)*100;
            x(i,j) = x(i,j)*featStds(i) + featMeans(i);
        end
    end

    for k=1:50:200
        figure;
        showFeatrue(x(:,k));
    end
end

function showFeatrue(fea)
    fea_size = 24*24;
    for i=1:7
        subplot(1,7,i)
        tmp_fea = fea((i-1)*fea_size+1 : i*fea_size);
        tmp_fea = reshape(tmp_fea,24,24);
        imshow(tmp_fea)
    end
end