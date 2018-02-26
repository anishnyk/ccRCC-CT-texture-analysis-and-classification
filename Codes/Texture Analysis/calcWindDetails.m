function [ windCount, windPerRow ] = calcWindDetails( I, windSize )
    
    [m,n] = size(I);
    windCount = floor((m/windSize)*(n/windSize));
    windPerRow = floor(n/windSize);

end

