function [clusterMat, statMat] = textureAnalysis(filePath, offset, windSize, clusters)
    
    % Read the image and convert to grayscale if required
    I = imread(filePath);
    
    if size(I,3) == 3
        IG = rgb2gray(I);
    else
        IG = I;
    end
    
    [ windCount, windPerRow ] = calcWindDetails( I, windSize );
    [m, n] = size(I);
    
    % evaluate Laws' texture energy measures
    lawMat = laws(IG, windSize/2);
    lawMatSize = size(lawMat, 2);
    
    energyMat = zeros(m, n, lawMatSize);
    for k=1:lawMatSize
        energyMat(:,:, k) = lawMat{1,k};
    end
    
    glc1Mat = zeros(8,8,windCount);
    glc2Mat = zeros(8,8,windCount);
    energyProps = zeros(1, lawMatSize);
    %statMat = zeros(windCount, 25);
    
    for i =1:windCount
        % evaluate start and end row & column for each window
        row = ceil(i/windPerRow);
        col = mod(i-1,windPerRow) + 1;
        beginRow = 1 + (row-1)*windSize;
        endRow = row*windSize;
        beginCol = 1 + (col-1)*windSize;
        endCol = col*windSize;
        
        % evaluate the GLC matrix for window
        glc1Mat(:,:,i) = graycomatrix( IG(beginRow:endRow,beginCol:endCol), 'Offset', [offset 0]);
        glc2Mat(:,:,i) = graycomatrix( IG(beginRow:endRow,beginCol:endCol), 'Offset', [0 offset]);
        
        % evaluate GLCM properties for window
        glcPropsRight = getGLCProps(glc1Mat(:,:,i));
        glcPropsDown = getGLCProps(glc2Mat(:,:,i));
        
        % evaluate Laws energy measures for window
        eMat = energyMat(beginRow:endRow,beginCol:endCol,:);
        eMeasures = mean(mean(eMat, 1),2);
        for j=1:lawMatSize
            energyProps(1,j) = eMeasures(:,:,j);
        end
        
        %[essenceMat, ~] = fourierAnalysis(IG(beginRow:endRow,beginCol:endCol), 30, 1, 0.5);
        
        %statMat(i,:) = [glcPropsRight glcPropsDown];
        statMat(i,:) = [energyProps glcPropsRight glcPropsDown ];
        
    end
    
    [J, clusterMat] = clusterImage( statMat, clusters, I, windSize);
    
    figure;colormap(gray(256));image(I);
    figure;colormap(gray(256));image(J);
        
end