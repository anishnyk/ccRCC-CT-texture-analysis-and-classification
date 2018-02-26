function [ aBucket, bBucket, cBucket ] = findBuckets( i,j,m,n, dTheta, dLambda )
    
    alpha = atan(abs((i-(m/2))/(j-(n/2)))) * 180/pi;
    beta = sqrt((i-(m/2))^2 + (j-(n/2))^2);
            
    if i<(m/2)
        if j<(n/2)
            gamma = 2;
        else
            gamma = 1;
        end
    else
        if j<(n/2)
            gamma = 3;
        else
            gamma = 4;
        end
    end
            
    aBucket = ceil(abs(alpha/dTheta));
    if aBucket<1
        aBucket=aBucket+1;
    elseif(isnan(aBucket))
        aBucket = 1;
    end
    bBucket = ceil(abs(beta/dLambda));
    if bBucket<1
        bBucket=bBucket+1;
    end
    cBucket = gamma;

end