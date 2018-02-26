function [eMeasures] = createCorrMatrix( lawMat )
    
    lawMatSize = size(lawMat, 2);
    [m,n] = size(lawMat{1,1});
    
    eMeasures = zeros(m*n, lawMatSize);
    
    for k=1:lawMatSize
        eMatrix = lawMat{1,k};

        for i =1:m
            for j=1:n
                row = n*(i-1) + j;
                col = k;
                eMeasures(row, col) = double(eMatrix(i,j));
            end
        end
    end

end