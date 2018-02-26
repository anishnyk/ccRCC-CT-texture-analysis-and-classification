function J = createClusters ( I, clusterMat, clusters)

    [m,n] = size(I);
    J = zeros(m,n);

    for i =1:m
        for j = 1:n
            row = n*(i-1) + j;
            J(i,j) = uint8(clusterMat(row, 1)/clusters*255);
        end
    end
end  