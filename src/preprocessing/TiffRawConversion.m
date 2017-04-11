FOLDER_NAME = 'new/';

for i = 1:17
   
    imageName = strcat('image_', num2str(i));
    tifName = strcat(FOLDER_NAME, imageName, '.tif');
    rawName = strcat(FOLDER_NAME, imageName, '.raw');
    rawFileID = fopen(rawName, 'w');
    
    image = imread(strcat(imageName, '.tif'));
    imageToWrite = uint16(image(1:4080, 1:4080));
    imwrite(imageToWrite, tifName);

    imageToWrite = imageToWrite';
    fwrite(rawFileID, imageToWrite, 'uint16', 'ieee-le');
    fclose(rawFileID);
end