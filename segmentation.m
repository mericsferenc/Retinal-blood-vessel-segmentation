
inputImage = imread('./original_images/tif/01_test.tif');

greenChannel = inputImage(:,:,2);

I_smooth = imgaussfilt(greenChannel, 2);

I_enhanced = adapthisteq(I_smooth);

h = fspecial('log', [5 5], 0.5);

I_log = imfilter(I_enhanced, h, 'replicate');

I_enhanced_edges = I_enhanced - I_log;

I_sharpened = imsharpen(I_enhanced_edges, 'Radius', 1, 'Amount', 4);

thresholdValue = graythresh(I_sharpened);
I_binarized_sharpened = imbinarize(I_sharpened, thresholdValue);




se = strel('disk', 1);
I_dilated = imdilate(I_binarized_sharpened, se);
I_temp_closed = imerode(I_dilated, se);
I_thinned = bwmorph(I_temp_closed, 'thin', 5);
I_dist_transform = bwdist(~I_thinned);
I_cond_dilated = imdilate(I_thinned, strel('disk', 1)) & (I_dist_transform < 4);
I_spur_removed = bwmorph(I_cond_dilated, 'spur', 5); 
I_final_inverted = ~I_spur_removed;


figure;
subplot(2,3,1), imshow(inputImage), title('Original Image');
subplot(2,3,2), imshow(I_enhanced), title('Enhanced Image');
subplot(2,3,3), imshow(I_enhanced_edges), title('LoG Filtered Image');
subplot(2,3,4), imshow(I_sharpened), title('Sharpened Image');
subplot(2,3,5), imshow(I_binarized_sharpened), title('Binarized Image');
subplot(2,3,6), imshow(I_final_inverted), title('Final Inverted Vessels');

imwrite(I_final_inverted, 'final_inverted_vessels.png');
