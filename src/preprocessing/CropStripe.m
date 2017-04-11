OFFSET = 16;
FRAME_LENGTH = 8160;
IMAGE_NAME = 'L0/Stripe/29.05.2015.Suluk.pan.L0';

image = imread(strcat(IMAGE_NAME, '.tif'));

for i = 1:8
   
    startIndex = OFFSET + 1 + ((i - 1) * FRAME_LENGTH);
    endIndex = startIndex + FRAME_LENGTH - 1;
    imageToWrite = uint16(image(startIndex:endIndex, 17:8176));
    imageToWrite = imageToWrite';
    
    rawFileID = fopen(strcat(IMAGE_NAME, '_', num2str(i), '.raw'), 'w');
    fwrite(rawFileID, imageToWrite, 'uint16', 'ieee-le');
    fclose(rawFileID);
end