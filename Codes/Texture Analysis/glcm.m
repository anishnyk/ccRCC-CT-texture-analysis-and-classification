function [statMat] = glcm(filePath, offset, windSize, clusters)
    % Read the image and convert to grayscale if required
    I = imread(filePath);
    
    if size(I,3) == 3
        IG = rgb2gray(I);
    else
        IG = I;
    end
    
    % create non-overlapping windows of given size
    % calculate GLCM texture properties for each window
    [m,n] = size(IG);
    windCount = (m/windSize)*(n/windSize);
    windPerRow = (n/windSize);
    glc1Mat = zeros(8,8,windCount);
    glc2Mat = zeros(8,8,windCount);
    %statMat = zeros(windCount, 7);
    for i =1:windCount
        % evaluate start and end row & column for each window
        row = ceil(i/windPerRow);
        col = mod(i-1,windPerRow) + 1;
        beginRow = 1 + (row-1)*windSize;
        endRow = row*windSize;
        beginCol = 1 + (col-1)*windSize;
        endCol = col*windSize;
        
        % evaluate the GLCM matrix
        glc1Mat(:,:,i) = graycomatrix( IG(beginRow:endRow,beginCol:endCol), 'Offset', [offset 0]);
        glc2Mat(:,:,i) = graycomatrix( IG(beginRow:endRow,beginCol:endCol), 'Offset', [0 offset]);
        % evaluate properties based on GLCM
        stats1 = getGLCProps(glc1Mat(:,:,i));
        stats2 = getGLCProps(glc2Mat(:,:,i));
        statMat(i,:) = [stats1 stats2];
    end
    
    clusterMat = kmeans(statMat, clusters);
%     windMat = zeros(clusters, 2);
    % J = zeros(m,n);
    for i=1:windCount
        row = ceil(i/windPerRow);
        col = mod(i-1,windPerRow) + 1;
        beginRow = 1 + (row-1)*windSize;
        endRow = row*windSize;
        beginCol = 1 + (col-1)*windSize;
        endCol = col*windSize;
        J(beginRow:endRow,beginCol:endCol) = uint8(clusterMat(i,1)/clusters*255);
%         if col<=(windPerRow/2)
%             windMat(clusterMat(i,1), 1) = windMat(clusterMat(i,1), 1) + 1;
%         else
%             windMat(clusterMat(i,1), 2) = windMat(clusterMat(i,1), 2) + 1;
%         end
    end
    
    figure;imshow(J);
%     figure;imshow(IG);
        
end