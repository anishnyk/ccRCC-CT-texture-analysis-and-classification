function [ stats ] = getGLCProps( glcMat )
    
    meanX = 0;
    meanY = 0;
    varX = 0;
    varY = 0;
    stdX = 0;
    stdY = 0;
    autoCorr = 0;
    energy = 0;
    contrast = 0;
    homogeneity = 0;
    entropy = 0;
    shade = 0;
    prominence = 0;
    dissimilarity = 0;
    variance = 0;
    invDiffNormalized = 0;
    InvDiffMomentNorm = 0;
    
    m = size(glcMat,2);
    glcmSum = sum(sum(glcMat));
    glcMat = glcMat/glcmSum;
    glcMean = mean2(glcMat);
    glcmVar  = (std2(glcMat))^2;
    maxProb = max(max(glcMat));
    
    pX = zeros(m,1); 
    pY = zeros(m,1); 
    pXPlusY = zeros((m*2 - 1),1); 
    pXMinusY = zeros(m,1); 
    hXY1 = 0;
    hXY2 = 0;
    hX  = 0;
    hY  = 0;
    
    sumAvg = 0;
    sumEntropy = 0;
    sumVariance = 0;
    diffEntropy = 0;
    diffVariance = 0;
    
%     for i=1:m
%         sumX = 0;
%         sumY = 0;
%         for j=1:m
%             sumX = sumX + glcMat(i,j);
%             sumY = sumY + j*glcMat(i,j);
%         end
%         meanX = meanX + sumX*i;
%         meanY = meanY + sumY;
%     end
        
    for i=1:m
        sumX = 0;
        sumY = 0;
        for j=1:m
            sumX = sumX + glcMat(i,j);
            sumY = sumY + glcMat(i,j)*(j-meanY)^2;
        end
        varX = varX + ((i-meanX)^2*sumX);
        varY = varY + sumY;
    end
    
    for i=1:m
        for j=1:m
            energy = energy + (glcMat(i,j)^2);
            contrast = contrast + (((i-j)^2)*glcMat(i,j));
            homogeneity = homogeneity + (glcMat(i,j)/(1 + abs(i-j)));
            entropy = entropy - glcMat(i,j)*log(glcMat(i,j) + 1);
            dissimilarity = dissimilarity + (abs(i - j)*glcMat(i,j));
            variance = variance + glcMat(i,j)*((i - glcMean)^2);
            invDiffNormalized = invDiffNormalized + (glcMat(i,j)/( 1 + (abs(i-j)/m) ));
            InvDiffMomentNorm = InvDiffMomentNorm + (glcMat(i,j)/( 1 + ((i - j)/m)^2));
            meanX = meanX + (i*glcMat(i,j));
            meanY = meanY + (j*glcMat(i,j));
            
            pX(i,1) = pX(i,1) + glcMat(i,j); 
            pY(i,1) = pY(i,1) + glcMat(j,i); % taking i for j and j for i
            if (ismember((i + j),2:2*m)) 
                pXPlusY((i+j)-1,1) = pXPlusY((i+j)-1,1) + glcMat(i,j);
            end
            if (ismember(abs(i-j),0:(m-1))) 
                pXMinusY((abs(i-j))+1,1) = pXMinusY((abs(i-j))+1,1) +...
                    glcMat(i,j);
            end
            
            shade = shade + glcMat(i,j)*(i+j-meanX-meanY)^3;
            prominence = prominence + glcMat(i,j)*(i+j-meanX-meanY)^4;
        end
    end
    
    for i = 1:(2*m-1)
        sumAvg = sumAvg + (i+1)*pXPlusY(i,1);
        sumEntropy = sumEntropy - (pXPlusY(i,1)*log(pXPlusY(i,1) + 1));
    end
    
    for i = 1:(2*m-1)
        sumVariance = sumVariance + (((i+1) - sumEntropy)^2)*pXPlusY(i,1);
    end
    
    for i = 0:(m-1)
        diffEntropy = diffEntropy - (pXMinusY(i+1,1)*log(pXMinusY(i+1,1) + 1));
        diffVariance = diffVariance + (i^2)*pXMinusY(i+1,1);
    end
    
    hXY = entropy;
    for i = 1:m
        for j = 1:m
            hXY1 = hXY1 - (glcMat(i,j)*log(pX(i,1)*pY(j,1) + 1));
            hXY2 = hXY2 - (pX(i,1)*pY(j,1)*log(pX(i,1)*pY(j,1) + 1));
        end
        hX = hX - (pX(i,1)*log(pX(i,1) + 1));
        hY = hY - (pY(i,1)*log(pY(i,1) + 1));
    end
    infoCorr1 = ( hXY - hXY1 ) / ( max([hX,hY]) );
    infoCorr2 = ( 1 - exp( -2*( hXY2 - hXY ) ) )^0.5;
    
    for i = 1:m
        for j = 1:m
            stdX  = stdX  + (((i) - meanX)^2)*glcMat(i,j);
            stdY  = stdY  + (((j) - meanY)^2)*glcMat(i,j);
            autoCorr = autoCorr + (((i) - meanX)*((j) - meanY)*glcMat(i,j));
        end
    end
    stdX = stdX ^ 0.5;
    stdY = stdY ^ 0.5;
    correlation = autoCorr / (stdX*stdY);
    
    stats = [autoCorr contrast correlation prominence shade dissimilarity ... 
        energy entropy homogeneity maxProb variance sumAvg sumVariance ...
        sumEntropy diffVariance diffEntropy infoCorr1 infoCorr2 ...
        invDiffNormalized InvDiffMomentNorm];
end