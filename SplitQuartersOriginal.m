QUARTER_NAME = 'image';
INPUT_FOLDER = 'Original/Tiff/Quarter/';
CLOUD_FOLDER = 'Original/Tiff/Tiles/Cloud/';
GROUND_FOLDER = 'Original/Tiff/Tiles/Ground/';
INDECISIVE_FOLDER = 'Original/Tiff/Tiles/Indecisive/';

NUMBER_OF_IMAGES = 62;
NUMBER_OF_QUARTERS = 4;
TILE_ROWS = 17;
TILE_COLS = 17;
TILE_SIZE = 240;

% class labels
GROUND_LABEL = 0;
CLOUD_LABEL = 1;

load('labels.mat');
cloudIndex = 1;
groundIndex = 1;
indecisiveIndex = 1;

for i = 1:NUMBER_OF_IMAGES
   
    for q = 1:NUMBER_OF_QUARTERS

        quarterImageName = strcat(INPUT_FOLDER, QUARTER_NAME, '_', num2str(i), ...
                                                              '_', num2str(q), '.tif');
        quarterImage = imread(quarterImageName);

        for r = 1:TILE_ROWS
            
            for c = 1:TILE_COLS
            
                if (labels(i, q, r, c) == CLOUD_LABEL)
                   
                    tileName = strcat(CLOUD_FOLDER, 'cloud.', num2str(cloudIndex));
                    cloudIndex = cloudIndex + 1;
                    
                elseif (labels(i, q, r, c) == GROUND_LABEL)
                    
                    tileName = strcat(GROUND_FOLDER, 'ground.', num2str(groundIndex));
                    groundIndex = groundIndex + 1;
                    
                else
                    tileName = strcat(INDECISIVE_FOLDER, 'indecisive.', num2str(indecisiveIndex));
                    indecisiveIndex = indecisiveIndex + 1;
                end
                
                rowStart = ((r - 1) * TILE_SIZE) + 1;
                rowEnd = r * TILE_SIZE;
                colStart = ((c - 1) * TILE_SIZE) + 1;
                colEnd = c * TILE_SIZE;
                tileImage = quarterImage(rowStart:rowEnd, colStart:colEnd);
                imwrite(tileImage, strcat(tileName, '.tif'));
            end
        end
    end
end