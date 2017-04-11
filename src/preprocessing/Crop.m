INPUT_FOLDER = 'L0/';
IMAGE_NAME = 'image.L0.frame';
NUMBER_OF_IMAGES = 19;

for i = 1:NUMBER_OF_IMAGES
   
    imageName = strcat(INPUT_FOLDER, IMAGE_NAME, {' ('}, num2str(i), ')');
    tifName = cell2mat(strcat(imageName, '.tif'));
    rawName = cell2mat(strcat(imageName, '.raw'));
    rawFileID = fopen(rawName, 'w');

    image = imread(tifName);
    imageToWrite = uint16(image(17:8176, 17:8176));

    imageToWrite = imageToWrite';
    fwrite(rawFileID, imageToWrite, 'uint16', 'ieee-le');
    fclose(rawFileID);
end