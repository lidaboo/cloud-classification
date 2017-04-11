function [trainX, trainY, valX, valY] = loadData(dataFile)

    TILE_LENGTH = 30;
    OFFSET = 2;
    SIGNIFICANT_PIXELS = (TILE_LENGTH - 2 * OFFSET) * (TILE_LENGTH - 2 * OFFSET);
    
    TRAIN_SET_ID = 1;
    VAL_SET_ID = 2;
    
    load(dataFile);

    trainSetSize = sum(images.set == TRAIN_SET_ID);
    valSetSize = sum(images.set == VAL_SET_ID);

    trainX = zeros(trainSetSize, SIGNIFICANT_PIXELS, 'single');
    trainY = zeros(trainSetSize, 1);

    valX = zeros(valSetSize, SIGNIFICANT_PIXELS, 'single');
    valY = zeros(valSetSize, 1);

    trainIndex = 1;
    valIndex = 1;

    for i = 1:numel(images.set)

        % 30x30 luk karonun en dýþýndaki 2 satýr ve sütunlarý alma
        imageData = images.data(1 + OFFSET:TILE_LENGTH - OFFSET, 1 + OFFSET:TILE_LENGTH - OFFSET, :, i);

        if images.set(1, i) == TRAIN_SET_ID

            trainX(trainIndex, :) = imageData(:);
            trainY(trainIndex, 1) = images.label(1, i);
            trainIndex = trainIndex + 1;
        else

            valX(valIndex, :) = imageData(:);
            valY(valIndex, 1) = images.label(1, i);
            valIndex = valIndex + 1;
        end
    end
end

