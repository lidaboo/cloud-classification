function [images, meta] = generateFoldEqualized(foldIndex, cloudImageData, groundImageData)

    TILE_SIZE = 240;
    NUMBER_OF_FOLDS = 10;
    NUMBER_OF_IMAGES = 12610;

    VALIDATION_START_INDEX = ((foldIndex - 1) * NUMBER_OF_IMAGES / NUMBER_OF_FOLDS) + 1;
    VALIDATION_END_INDEX = VALIDATION_START_INDEX + (NUMBER_OF_IMAGES / NUMBER_OF_FOLDS) - 1;

    OUTPUT_FOLDER = 'Original/CV/EqualClasses/';
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
    for i = 1:VALIDATION_START_INDEX - 1

        images.label(imageIndex) = CLOUD_LABEL;
        images.set(imageIndex) = TRAIN_SET_ID;
        images.data(1:TILE_SIZE, 1:TILE_SIZE, :, imageIndex) = cloudImageData{i};
        imageIndex = imageIndex + 1;
    end

    % ground tiles in training
    for i = 1:VALIDATION_START_INDEX - 1

        images.label(imageIndex) = GROUND_LABEL;
        images.set(imageIndex) = TRAIN_SET_ID;
        images.data(1:TILE_SIZE, 1:TILE_SIZE, :, imageIndex) = groundImageData{i};
        imageIndex = imageIndex + 1;
    end

    % cloud tiles in validation
    for i = VALIDATION_START_INDEX:VALIDATION_END_INDEX

        images.label(imageIndex) = CLOUD_LABEL;
        images.set(imageIndex) = VALIDATION_SET_ID;
        images.data(1:TILE_SIZE, 1:TILE_SIZE, :, imageIndex) = cloudImageData{i};
        imageIndex = imageIndex + 1;
    end

    % ground tiles in validation
    for i = VALIDATION_START_INDEX:VALIDATION_END_INDEX

        images.label(imageIndex) = GROUND_LABEL;
        images.set(imageIndex) = VALIDATION_SET_ID;
        images.data(1:TILE_SIZE, 1:TILE_SIZE, :, imageIndex) = groundImageData{i};
        imageIndex = imageIndex + 1;
    end

    % remaining cloud tiles in training
    for i = VALIDATION_END_INDEX + 1:NUMBER_OF_IMAGES

        images.label(imageIndex) = CLOUD_LABEL;
        images.set(imageIndex) = TRAIN_SET_ID;
        images.data(1:TILE_SIZE, 1:TILE_SIZE, :, imageIndex) = cloudImageData{i};
        imageIndex = imageIndex + 1;
    end

    % remaining ground tiles in training
    for i = VALIDATION_END_INDEX + 1:NUMBER_OF_IMAGES

        images.label(imageIndex) = GROUND_LABEL;
        images.set(imageIndex) = TRAIN_SET_ID;
        images.data(1:TILE_SIZE, 1:TILE_SIZE, :, imageIndex) = groundImageData{i};
        imageIndex = imageIndex + 1;
    end

    % write the current fold
    outputFileName = strcat(OUTPUT_FOLDER, OUTPUT_FILE_NAME, '.', num2str(foldIndex), '.mat');
    save(outputFileName, 'images', 'meta', '-v7.3');
end