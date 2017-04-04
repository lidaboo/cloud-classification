function [images, meta] = generateFold(foldIndex, cloudImageData, groundImageData)

    TILE_SIZE = 240;
    NUMBER_OF_FOLDS = 10;
    
    NUMBER_OF_CLOUD_IMAGES = 12610;
    NUMBER_OF_GROUND_IMAGES = 50990;

    CLOUD_VALIDATION_START_INDEX = ...
        ((foldIndex - 1) * NUMBER_OF_CLOUD_IMAGES / NUMBER_OF_FOLDS) + 1;
    
    CLOUD_VALIDATION_END_INDEX = ...
        CLOUD_VALIDATION_START_INDEX + (NUMBER_OF_CLOUD_IMAGES / NUMBER_OF_FOLDS) - 1;

    GROUND_VALIDATION_START_INDEX = ...
        ((foldIndex - 1) * NUMBER_OF_GROUND_IMAGES / NUMBER_OF_FOLDS) + 1;
    
    GROUND_VALIDATION_END_INDEX = ...
        GROUND_VALIDATION_START_INDEX + (NUMBER_OF_GROUND_IMAGES / NUMBER_OF_FOLDS) - 1;

    OUTPUT_FOLDER = 'Original/CV/Simple/';
    CLOUD_IMAGE_NAME = 'cloud';
    GROUND_IMAGE_NAME = 'ground';
    OUTPUT_FILE_NAME = 'imdb.fold';

    TRAIN_SET_ID = uint8(1);
    VALIDATION_SET_ID = uint8(2);

    CLOUD_LABEL = single(1);
    GROUND_LABEL = single(2);

    meta.classes{CLOUD_LABEL, 1} = CLOUD_IMAGE_NAME;
    meta.classes{GROUND_LABEL, 1} = GROUND_IMAGE_NAME;
    meta.sets = {'train', 'val'};

    imageIndex = 1;

    % cloud tiles in training
    for i = 1:CLOUD_VALIDATION_START_INDEX - 1
        
        images.label(imageIndex) = CLOUD_LABEL;
        images.set(imageIndex) = TRAIN_SET_ID;
        images.data(1:TILE_SIZE, 1:TILE_SIZE, :, imageIndex) = cloudImageData{i};
        imageIndex = imageIndex + 1;
    end

    % ground tiles in training
    for i = 1:GROUND_VALIDATION_START_INDEX - 1

        images.label(imageIndex) = GROUND_LABEL;
        images.set(imageIndex) = TRAIN_SET_ID;
        images.data(1:TILE_SIZE, 1:TILE_SIZE, :, imageIndex) = groundImageData{i};
        imageIndex = imageIndex + 1;
    end

    % cloud tiles in validation
    for i = CLOUD_VALIDATION_START_INDEX:CLOUD_VALIDATION_END_INDEX

        images.label(imageIndex) = CLOUD_LABEL;
        images.set(imageIndex) = VALIDATION_SET_ID;
        images.data(1:TILE_SIZE, 1:TILE_SIZE, :, imageIndex) = cloudImageData{i};
        imageIndex = imageIndex + 1;
    end

    % ground tiles in validation
    for i = GROUND_VALIDATION_START_INDEX:GROUND_VALIDATION_END_INDEX

        images.label(imageIndex) = GROUND_LABEL;
        images.set(imageIndex) = VALIDATION_SET_ID;
        images.data(1:TILE_SIZE, 1:TILE_SIZE, :, imageIndex) = groundImageData{i};
        imageIndex = imageIndex + 1;
    end

    % remaining cloud tiles in training
    for i = CLOUD_VALIDATION_END_INDEX + 1:NUMBER_OF_CLOUD_IMAGES

        images.label(imageIndex) = CLOUD_LABEL;
        images.set(imageIndex) = TRAIN_SET_ID;
        images.data(1:TILE_SIZE, 1:TILE_SIZE, :, imageIndex) = cloudImageData{i};
        imageIndex = imageIndex + 1;
    end

    % remaining ground tiles in training
    for i = GROUND_VALIDATION_END_INDEX + 1:NUMBER_OF_GROUND_IMAGES

        images.label(imageIndex) = GROUND_LABEL;
        images.set(imageIndex) = TRAIN_SET_ID;
        images.data(1:TILE_SIZE, 1:TILE_SIZE, :, imageIndex) = groundImageData{i};
        imageIndex = imageIndex + 1;
    end

    % write the current fold
    outputFileName = strcat(OUTPUT_FOLDER, OUTPUT_FILE_NAME, '.', num2str(foldIndex), '.mat');
    save(outputFileName, 'images', 'meta', '-v7.3');
end