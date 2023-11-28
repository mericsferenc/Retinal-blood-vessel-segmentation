
inputImage = imread('./original_images/tif/02_test.tif');

greenChannel = inputImage(:,:,2);
I_enhanced = adapthisteq(greenChannel);
I_masked = I_enhanced;
I_masked(~mask) = 0;

se = strel('disk', 15);
I_top_hat = imtophat(I_masked, se);

level = graythresh(I_top_hat);
I_otsu = imbinarize(I_top_hat, level);

I_cleaned = bwareaopen(I_otsu, 30);

se2 = strel('disk', 3);
I_thick_vessels = imclose(I_cleaned, se2);

I_thin_vessels = I_top_hat & ~I_thick_vessels;

I_final_vessels = I_thick_vessels | I_thin_vessels;

figure;
subplot(1,2,1), imshow(inputImage), title('Original Image');
subplot(1,2,2), imshow(I_final_vessels), title('Segmented');
