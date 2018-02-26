I = imread('CT_RCC.jpg');

im = I(:,:,3);
figure;
imshow(im);
h = imfreehand();

roi = uint8(createMask(h));
J = roi.*im;

imshow(J);