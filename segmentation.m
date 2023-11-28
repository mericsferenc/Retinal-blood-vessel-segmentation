inputImage = imread('01_test.tif');

greenChannel = inputImage(:,:,2);

I_denoised = medfilt2(greenChannel, [3 3]);

I_enhanced = adapthisteq(I_denoised);

sigma = 2;
hsize = 15;
I_log = fspecial('log', hsize, sigma);
I_edge = imfilter(I_enhanced, I_log, 'same', 'replicate');
I_edge = mat2gray(abs(I_edge));

I_sharpened = imsharpen(I_edge, 'Radius', 1, 'Amount', 1.5);

thresholdValue = graythresh(I_sharpened);
I_binarized = imbinarize(I_sharpened, thresholdValue);

figure;
subplot(2,4,1), imshow(inputImage), title('Original Image');
subplot(2,4,2), imshow(I_denoised), title('Denoised Image');
subplot(2,4,3), imshow(I_enhanced), title('Enhanced Image');
subplot(2,4,4), imshow(I_edge), title('LoG Filtered Image');
subplot(2,4,5), imshow(I_sharpened), title('Sharpened Image');
subplot(2,4,6), imshow(I_binarized), title('Binarized Image');