inputImage = imread('./original_images/tif/01_test.tif');



greenChannel = inputImage(:,:,2);
I_smooth = imgaussfilt(greenChannel, 2); 

I_enhanced = adapthisteq(I_smooth);

figure;
subplot(1,1,1), imshow(inputImage), title('Original Image');
subplot(1,1,2), imshow(I_enhanced), title('Original Image');