INPUT_FOLDER = 'DWT/Tiff/Whole/';
OUTPUT_FOLDER = 'DWT/Tiff/Quarter/';
IMAGE_NAME = 'imageDWT_';
NUMBER_OF_IMAGES = 62;

for i = 1:NUMBER_OF_IMAGES
   
    imageName = strcat(INPUT_FOLDER, IMAGE_NAME, num2str(i), '.tif');
    image = imread(imageName);
    
    topLeftName = strcat(OUTPUT_FOLDER, IMAGE_NAME, num2str(i), '_1.tif');
    topRightName = strcat(OUTPUT_FOLDER, IMAGE_NAME, num2str(i), '_2.tif');
    bottomLeftName = strcat(OUTPUT_FOLDER, IMAGE_NAME, num2str(i), '_3.tif');
    bottomRightName = strcat(OUTPUT_FOLDER, IMAGE_NAME, num2str(i), '_4.tif');
    
    topLeft = image(1:end/2, 1:end/2);
    topRight = image(end/2+1:end, 1:end/2);
    bottomLeft = image(1:end/2, end/2+1:end);
    bottomRight = image(end/2+1:end, end/2+1:end);
    
    imwrite(topLeft, topLeftName);
    imwrite(topRight, topRightName);
    imwrite(bottomLeft, bottomLeftName);
    imwrite(bottomRight, bottomRightName);
end