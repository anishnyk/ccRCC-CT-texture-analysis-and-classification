function [ essence ] = findEssence( intensity )

    [m,~,n] = size(intensity);
    essMat = ones(1, m*n);
    k=1;
    
    for i=1:n
        for j=abs((mod(i,2)*(m+1))-m):(-1)+2*mod(i,2):abs((mod(i,2)*(m+1))-1)
        %for j=1:m
            essMat(k) = std(intensity(j,:,i))/mean((intensity(j,:,i)));
            k=k+1;
        end
    end
    
    [~, pos] = max(essMat);
    
    essence = [essMat(1, pos:m*n) essMat(1, 1:pos-1)];

end

