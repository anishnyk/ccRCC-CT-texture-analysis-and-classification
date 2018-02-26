function resizeScans(filePath, newSize)

    delimiter = '';
    formatSpec = '%s%[^\n\r]';
    fileID = fopen(filePath,'r');
    
    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
    fclose(fileID);

    fileList = dataArray{:, 1};
    [m,~] = size(fileList);
    
    if nargin == 1
        newSize = 100;
    end
    
    for i=1:m
        
        RGB = imread(fileList{i});
        if size(RGB,3) > 1
            gray = im2gray(RGB);
        else
            gray = RGB;
        end

        BW = imbinarize(gray);

        s = regionprops(BW,'centroid');
        centroids = cat(1, round(s.Centroid));

        I = RGB(centroids(2)-(newSize/2):centroids(2)+(newSize/2)-1,centroids(1)-(newSize/2):centroids(1)+(newSize/2)-1);
        imwrite(I, strcat('resized/',fileList{i}));
    end
    
end

