NUMBER_OF_IMAGES = 62;
ROWS = 8160;
COLS = 8160;

for i = 1:NUMBER_OF_IMAGES
   
    inputImageName = strcat('Raw/image (' , num2str(i), ')');
    outputImageName = strcat('Tiff/image_' , num2str(i));
    
    fin = fopen(strcat(inputImageName, '.raw'), 'r');
    I = fread(fin, ROWS * COLS, 'uint16=>uint16'); 
    Z = reshape(I, ROWS, COLS);
    Z = Z';
    imwrite(Z, strcat(outputImageName, '.tif'));
end