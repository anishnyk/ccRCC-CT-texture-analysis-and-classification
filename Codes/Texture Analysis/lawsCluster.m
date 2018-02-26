function lawsCluster (filePath, averWindSize, clusters)
    I = imread(filePath);
    I = I(1:40,1:40);
    
    if size(I, 3) == 3
        IG = rgb2gray(I);
    else
        IG = I;
    end
    
    lawMat = laws(IG, averWindSize);
    [energyMat] = createCorrMatrix( lawMat);
    
    kMat = kmeans( energyMat, clusters);
    J1 = createClusters( IG, kMat, clusters);
    
    distMat = pdist(energyMat,'seuclidean');
    linkMat = linkage(distMat, 'ward');
    hierMat = cluster(linkMat, 'maxclust', clusters);
    J2 = createClusters( IG, hierMat, clusters);
    
%     pixelCount = zeros(clusters, 2);
%     [m,n] = size(J);
%     for i=1:m
%         for j=1:n/2
%             row = (J(i,j) - 1)/127;
%             pixelCount(row,1) = pixelCount(row,1) + 1;
%         end
%         for j=(n/2)+1:n
%             row = (J(i,j) - 1)/127;
%             pixelCount(row,2) = pixelCount(row,2) + 1;
%         end
%     end
    
    figure; colormap(gray(256)); image(IG);
    figure; colormap(gray(256)); image(J1);
    figure; colormap(gray(256)); image(J2);
end