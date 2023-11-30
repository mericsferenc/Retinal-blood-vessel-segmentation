inputDir = './original_images/tif/';
outputDirTif = './segmented_images/tif/';
outputDirPng = './segmented_images/png/';

if ~exist(outputDirTif, 'dir')
    mkdir(outputDirTif);
end

if ~exist(outputDirPng, 'dir')
    mkdir(outputDirPng);
end


imageFiles = dir(fullfile(inputDir, '*.tif'));

for i = 1:length(imageFiles)
    inputImagePath = fullfile(inputDir, imageFiles(i).name);
    inputImage = imread(inputImagePath);
    
    % extract the green channel
    greenChannel = inputImage(:,:,2);
    
    % noise reduction with median filtering
    I_denoised = medfilt2(greenChannel, [3 3]);
    
    % contrast enhancement using adaptive histogram equalization (CLAHE)
    I_enhanced = adapthisteq(I_denoised);
    
    % edge detection using LoG filter
    sigma = 2;
    hsize = 15;
    I_log = fspecial('log', hsize, sigma);
    I_edge = imfilter(I_enhanced, I_log, 'same', 'replicate');
    I_edge = mat2gray(abs(I_edge)); % convert to grayscale image
    
    % sharpen
    I_sharpened = imsharpen(I_edge, 'Radius', 2, 'Amount', 2);
    
    % binarize using a threshold determined by Otsu's method
    thresholdValue = graythresh(I_sharpened);
    I_binarized = imbinarize(I_sharpened, thresholdValue);
    
    % morphological opening to remove small objects that are not vessels: 
    I_opened = bwareaopen(I_binarized, 50); % increasing this value reduces the number of small noises, but if it is too high, thin vessels disappear
    
    [~, fileName, ~] = fileparts(imageFiles(i).name);
    outputImagePathTif = fullfile(outputDirTif, [fileName, '_segmented.tif']);
    outputImagePathPng = fullfile(outputDirPng, [fileName, '_segmented.png']);
    
    imwrite(I_opened, outputImagePathTif);
    imwrite(I_opened, outputImagePathPng);
    
    %     figure;
    %     subplot(2,4,1), imshow(inputImage), title('Original Image');
    %     subplot(2,4,2), imshow(I_denoised), title('Denoised Image');
    %     subplot(2,4,3), imshow(I_enhanced), title('Enhanced Image');
    %     subplot(2,4,4), imshow(I_edge), title('LoG Filtered Image');
    %     subplot(2,4,5), imshow(I_sharpened), title('Sharpened Image');
    %     subplot(2,4,6), imshow(I_binarized), title('Binarized Image');
    %     subplot(2,4,7), imshow(I_opened), title('Opened Image');
end
