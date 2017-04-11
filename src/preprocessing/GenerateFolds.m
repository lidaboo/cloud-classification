NUMBER_OF_FOLDS = 10;

NUMBER_OF_CLOUD_IMAGES = 12610;
NUMBER_OF_GROUND_IMAGES = 50990;

CLOUD_FOLDER = 'Original/Tiff/Tiles/Cloud/';
GROUND_FOLDER = 'Original/Tiff/Tiles/Ground/';

CLOUD_IMAGE_NAME = 'cloud';
GROUND_IMAGE_NAME = 'ground';

cloudImageData = cell(1, NUMBER_OF_CLOUD_IMAGES);
groundImageData = cell(1, NUMBER_OF_GROUND_IMAGES);

for c = 1:NUMBER_OF_CLOUD_IMAGES
    
    imageName = strcat(CLOUD_FOLDER, CLOUD_IMAGE_NAME, ' (', num2str(c), ').tif');
    cloudImageData{c} = im2single(imread(imageName));
end

for g = 1:NUMBER_OF_GROUND_IMAGES
    
    imageName = strcat(GROUND_FOLDER, GROUND_IMAGE_NAME, ' (', num2str(g), ').tif');
    groundImageData{g} = im2single(imread(imageName));
end

save('Original/CV/imageData.mat', 'cloudImageData', 'groundImageData', '-v7.3');

for f = 1:NUMBER_OF_FOLDS
   
    [images{f}, meta{f}] = generateFoldEqualized(f, cloudImageData, groundImageData);
    disp(strcat('Fold', {' '}, num2str(f), ' completed.'));
end