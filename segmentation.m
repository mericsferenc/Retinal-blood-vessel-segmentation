inputImage = imread('./original_images/tif/01_test.tif');

greenChannel = inputImage(:,:,2);
I_smooth = imgaussfilt(greenChannel, 2);

% Contrast enhancement using CLAHE
I_enhanced = adapthisteq(I_smooth);

orientations = 0:80:160;
smaller_wavelengths = 2:2:8;
I_matched_small = zeros(size(I_enhanced));
for angle = orientations
    for wavelength = smaller_wavelengths
        [mag, ~] = imgaborfilt(I_enhanced, wavelength, angle);
        I_matched_small = max(I_matched_small, mag);
    end
end

I_matched_small_normalized = mat2gray(I_matched_small);

I_sharpened = imsharpen(I_matched_small_normalized, 'Radius', 5, 'Amount', 5);

figure;
subplot(1,3,1), imshow(inputImage), title('Original Image');
subplot(1,3,2), imshow(I_matched_small_normalized, []), title('Normalized Small Vessels Gabor Response');
subplot(1,3,3), imshow(I_sharpened, []), title('Sharpened Small Vessels Response');