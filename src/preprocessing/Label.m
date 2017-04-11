%% Initialize some constants

% number of images labeled so far
COMPLETED_IMAGES = 62;

% image properties
IMAGE_NAME = 'DWT/Tiff/Quarter/imageDWT_';
NUMBER_OF_IMAGES = 62;
NUMBER_OF_TILES = 4;
TILE_ROWS = 17;
TILE_COLS = 17;
TILE_HEIGHT = 30;
TILE_WIDTH = 30;

% mouse buttons
LEFT_BUTTON_ID = 1;
MIDDLE_BUTTON_ID = 2;
RIGHT_BUTTON_ID = 3;

% class labels
NOT_CLOUDY = 0;
CLOUDY = 1;
INDECISIVE = 2;

load('grid.mat');


%% Load or initialize the labels

% labels = zeros(NUMBER_OF_IMAGES, NUMBER_OF_TILES, TILE_ROWS, TILE_COLS, 'uint8');
load('labels.mat');
status(labels, COMPLETED_IMAGES, TILE_COLS, TILE_ROWS);


%% Sequentially display the image quarters to the user

for i = COMPLETED_IMAGES + 1:NUMBER_OF_IMAGES
    
    for j = 1:NUMBER_OF_TILES
       
        imageName = strcat(IMAGE_NAME, num2str(i), '_', num2str(j), '.tif');
        image = imread(imageName);
        gridImage = image * 32 + grid;
        
        imshow(gridImage);
        header = strcat('IMAGE: ', num2str(i), ' TILE: ', num2str(j));
        title(header);
        
        % display the image in fullscreen
        set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
        
        while true
            
            % get the position of the selected pixel
            [col, row, button] = ginput(1);
                      
            % middle button advances to the next image part
            if (button == MIDDLE_BUTTON_ID)
               
                break
            else
                
                % calculate index of the selected tile
                tileRowIndex = 1 + floor(row / TILE_HEIGHT);
                tileColIndex = 1 + floor(col / TILE_WIDTH);
               
                if (button == LEFT_BUTTON_ID)
                  
                    % left button labels the tile as cloudy
                    labels(i, j, tileRowIndex, tileColIndex) = CLOUDY;
                   
                elseif (button == RIGHT_BUTTON_ID)
                  
                    % right button labels the tile as indecisive
                    labels(i, j, tileRowIndex, tileColIndex) = INDECISIVE;
                end
               
                % display labels for the part
                squeeze(labels(i, j, :, :))
            end
        end 
        
        % save the labels after the part is completed
        save('labels.mat', 'labels');
        fprintf('----------------\nimage: %d part: %d\n', i, j);
        fprintf('labels.mat saved\n----------------\n');
    end
    status(labels, i, TILE_COLS, TILE_ROWS);
end
