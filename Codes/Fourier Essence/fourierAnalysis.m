function [essenceMat, J] = fourierAnalysis(I, dTheta, dLambda, dThresh)
    
    % I = imread(filePath);
    [m,n] = size(I);
    
    if size(I,3) == 3
        I = rgb2gray(I);
    end
    
    % fourier transform
    Ifft = fftshift(log(abs(fft2(I))));
    maxVal = max(max(Ifft));
    minVal = min(min(Ifft));
    threshVal = minVal + (maxVal-minVal)*dThresh;
    
    % find max value of dimensions of count and intensity matrices
    [~, bBucket, ~] = findBuckets(0, n, m, n, dTheta, dLambda);
    aBucket = ceil(90/dTheta);
    count = ones(aBucket, bBucket, 4);
    intensity = zeros(aBucket, bBucket, 4);
    
    % for each pixel, find bucket and increment count and intensity 
    for i=1:m
        for j=1:n
            [aBucket, bBucket, cBucket] = findBuckets( i,j,m,n, dTheta, dLambda );
            if aBucket<1 || bBucket<1 || cBucket<1
                msg = strcat('i',num2str(i),' j',num2str(j));
                error(msg);
            end
            count(aBucket, bBucket, cBucket) = count(aBucket, bBucket, cBucket) + 1;
            if Ifft(i,j)>threshVal
                intenVal = Ifft(i,j);
            else
                intenVal = 0;
            end
            intensity(aBucket, bBucket, cBucket) =  intensity(aBucket, bBucket, cBucket) + intenVal;
            
        end
    end
    
    % for each pixel, replace intensity with avg intensity of bucket
    J = zeros(m,n);
    for i=1:m
        for j=1:n
            [aBucket, bBucket, cBucket] = findBuckets( i,j,m,n, dTheta, dLambda );
            if aBucket<1 || bBucket<1 || cBucket<1
                msg = strcat('i',num2str(i),' j',num2str(j));
                error(msg);
            end 
            
            J(i,j) = intensity(aBucket, bBucket, cBucket)/(count(aBucket, bBucket, cBucket)-1);
            
        end
    end
    
    % essence matrix for each alphaBucket
    essenceMat = findEssence(intensity);

end