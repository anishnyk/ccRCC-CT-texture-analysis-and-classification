function [ J, clusterMat ] = clusterImage( statMat, clusters, I, windSize )

    distMat = pdist(statMat,'seuclidean');
    linkMat = linkage(distMat, 'ward');
    hierMat = cluster(linkMat, 'maxclust', clusters);
    
    [ windCount, windPerRow ] = calcWindDetails( I, windSize );

    [m, n] = size(I);
    J = zeros(m,n);
    clusterMat = zeros(clusters, clusters);
    
    for i=1:windCount
        row = ceil(i/windPerRow);
        col = mod(i-1,windPerRow) + 1;
        beginRow = 1 + (row-1)*windSize;
        endRow = row*windSize;
        beginCol = 1 + (col-1)*windSize;
        endCol = col*windSize;
        
        J(beginRow:endRow,beginCol:endCol) = uint8(hierMat(i,1)/clusters*255);
        
        clusterMat(ceil(2*col/windPerRow),hierMat(i,1)) = clusterMat(ceil(2*col/windPerRow),hierMat(i,1)) + 1;

    end

end

