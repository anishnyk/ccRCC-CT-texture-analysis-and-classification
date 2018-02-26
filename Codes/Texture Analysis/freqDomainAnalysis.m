function [essCorrFP1, essCorrFP2, essCorrP1P2] = freqDomainAnalysis( filePath, theta, lambda, thresh, part, iterations )
    
    A = size(theta, 2);
    B = size(lambda, 2);
    C = size(thresh, 2);
    D = size(part, 2);
    
    I = imread(filePath);
    [m,n] = size(I);
    
    if size(I,3) == 3
        I = rgb2gray(I);
    end
    ILarge = [I I;I I];
    
    essCorrFP1 = zeros(A,B,C,D,iterations);
    essCorrFP2 = zeros(A,B,C,D,iterations);
    essCorrP1P2 = zeros(A,B,C,D,iterations);
    
    for a=1:A
        for b=1:B
            for c=1:C
                for d=1:D
                    for i=1:iterations
                        
                        m1 = randi(m);
                        n1 = randi(n);
                        a1 = rand*pi/2;
                        I1Large = rotateImage(ILarge, a1);

                        m2 = randi(m);
                        n2 = randi(n);
                        a2 = rand*pi/2;
                        I2Large = rotateImage(ILarge, a2);

                        test1 = I1Large(m1:m1+round(m/part(d))-1,n1:n1+round(n/part(d))-1);
                        test2 = I2Large(m2:m2+round(m/part(d))-1,n2:n2+round(n/part(d))-1);

                    %     [essMat1, J1] = fourierAnalysis(test1, 15, 5, 0.5);
                    %     [essMat2, J2] = fourierAnalysis(test2, 15, 5, 0.5);
                    %     [essMat, J] = fourierAnalysis(I, 15, 5, 0.5);

                        [essMat1, ~] = fourierAnalysis(test1, theta(a), lambda(b), thresh(c));
                        [essMat2, ~] = fourierAnalysis(test2, theta(a), lambda(b), thresh(c));
                        [essMat, ~] = fourierAnalysis(I, theta(a), lambda(b), thresh(c));

                    %     figure;colormap(gray(256));imagesc(J1);
                    %     figure;colormap(gray(256));imagesc(J2);
                    %     figure;colormap(gray(256));imagesc(J);
                    %     
                    %     figure;colormap(gray(256));imagesc(test1);
                    %     figure;colormap(gray(256));imagesc(test2);
                    %     
                    %     figure; plot(essMat1,'r');
                    %     hold on; plot(essMat2,'b');
                    %     hold on; plot(essMat,'g');

                        essComp = [essMat; essMat1; essMat2].';
                        essCorr = corr(essComp);
                        essCorrFP1(a,b,c,d,i) = essCorr(1,2);
                        essCorrFP2(a,b,c,d,i) = essCorr(1,3);
                        essCorrP1P2(a,b,c,d,i) = essCorr(2,3);
                    end
                end
            end
        end
    end

end
