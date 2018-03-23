function [imMat] = createTrainSet(filePath, offset)
    
    % add all sub-folders in current directory to the MATLAB path
    addpath(genpath(pwd));
    
    % initiate file import parameters
    delimiter = '';
    formatSpec = '%s%[^\n\r]';
    fileID = fopen(filePath,'r');
    
    % import file list of resized tumor scans into fileList
    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
    fclose(fileID);
    fileList = dataArray{:, 1};
    [fileSize,~] = size(fileList);
    
    imMat = [];
    
    % iterate through fileList and extract features 
    % from resized tumor scans
    for a=1:fileSize
        
        % import resized tumor scan as matrix 
        % convert to grayscale if RGB image
        RGB = imread(strcat('Assets/Tumor slides/resized/',fileList{a}));
        
        if size(RGB,3) > 1
            I = im2gray(RGB);
        else
            I = RGB;
        end
        
        % pad tumor area with NaN values to extract accurate features
        % create new double matrix to be able to hold NaN values
        [m, n] = size(I);
        IG = double(zeros(m,n));
        for i=1:m
            for j=1:n
                if I(i,j)==0
                    IG(i,j) = NaN;
                else
                    IG(i,j) = double(I(i,j));
                end
            end
        end
        
%          % evaluate Laws' texture energy measures
%          lawMat = laws(I, round(m/10));
%          lawMatSize = size(lawMat, 2);
% 
%          energyMat = zeros(m, n, lawMatSize);
%          for k=1:lawMatSize
%             energyMat(:,:, k) = lawMat{1,k};
%          end
% 
%          energyProps = zeros(1, lawMatSize);
%          for j=1:lawMatSize
%              energyProps(1,j) = mean(mean(energyMat(:,:,j)));
%          end
         
        % compute gray-level run-length matrix (GLRLM) with 
        % 256 gray levels and the default 4 angles
        [GLRLMS,~]= grayrlmatrix(I, 'G', [0 255], 'N', 256);
        for i=1:4
            GLRLangle = GLRLMS{i};
            GLRLangle(1,:) = zeros(1,n);
            GLRLMS{i} = GLRLangle;
        end
        
        % extract 11 features from GLRLM for all 4 angles
        stats = grayrlprops(GLRLMS);
        glrlmsProps = mean(stats);

        % compute gray-level co-occurence matrix (GLCM)
        % 256 gray levels and 0, 45, 90 and 135 degrees
        offsets = [0 offset; -offset offset; -offset 0; -offset -offset];
        glcMat = graycomatrix( IG, 'Offset', offsets, 'GrayLimits', [0,255],'NumLevels', 256);
        
        % sum over all 4 GLCMs and extract 20 texture features
        neighbors = size(glcMat,3);
        glcm = zeros(size(glcMat,1),size(glcMat,2));
        for k=1:neighbors
            glcm = glcm + glcMat(:,:,k);
        end
        glcProps = getGLCProps(glcm);
         
%         % extract Fourier essence feature vector
%         % 30 degree angle buckets and 2 pixel radius buckets
%         [essenceMat, ~] = fourierAnalysis(I, 30, 1, 0.5);
        
        % extract 7 Hu's moment features 
        eta = SI_Moment(I);
        inv_moments = Hu_Moments(eta);
        
        % concatenate all extracted features
        % 11 GLRLM + 20 GLCM + 7 Hu's moments
        imRowMat = horzcat(glrlmsProps, glcProps, inv_moments);
        imMat = vertcat(imMat, imRowMat);
        
    end
end