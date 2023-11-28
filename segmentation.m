inputImage = imread('./original_images/tif/01_test.tif'); % Replace with your actual file name

greenChannel = inputImage(:,:,2);
I_smooth = imgaussfilt(greenChannel, 2); % Adjust the sigma value as needed
I_enhanced = adapthisteq(I_smooth);

orientations = 0:20:160;
smaller_wavelengths = 2:1:8;
I_matched_small = zeros(size(I_enhanced));
for angle = orientations
    for wavelength = smaller_wavelengths
        [mag, ~] = imgaborfilt(I_enhanced, wavelength, angle);
        I_matched_small = max(I_matched_small, mag);
    end
end

I_matched_small_normalized = mat2gray(I_matched_small);

I_sharpened = imsharpen(I_matched_small_normalized, 'Radius', 2, 'Amount', 4);

thresholdValue = graythresh(I_sharpened); 
I_binarized_sharpened = imbinarize(I_sharpened, thresholdValue);

se = strel('disk', 2);
I_dilated = imdilate(I_binarized_sharpened, se);
I_temp_closed = imerode(I_dilated, se);

I_thinned = bwmorph(I_temp_closed, 'thin', 5);

I_dist_transform = bwdist(~I_thinned);

I_cond_dilated = imdilate(I_thinned, strel('disk', 1)) & (I_dist_transform < 4);

I_spur_removed = bwmorph(I_cond_dilated, 'spur', 5); 


figure;
subplot(3,4,1), imshow(inputImage), title('img 1');
subplot(3,4,2), imshow(I_matched_small_normalized, []), title('img 2');
subplot(3,4,3), imshow(I_sharpened, []), title('img 3');
subplot(3,4,4), imshow(I_binarized_sharpened), title('img 4');
subplot(3,4,5), imshow(I_temp_closed), title('img 5');
subplot(3,4,6), imshow(I_thinned), title('img 6');
subplot(3,4,7), imshow(I_cond_dilated), title('img 7');
subplot(3,4,8), imshow(I_spur_removed), title('img 8');


