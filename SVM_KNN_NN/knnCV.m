function [avgAccuracyTrain, avgAccuracyCV] = knnCV(numberOfNeighbors)
    
    NUMBER_OF_FOLDS = 10;
    DATA_FILE_NAME_SUBSTRING = '../DWT/CV/EqualClasses/imdb.fold.';

    trainingAccuracy = zeros(NUMBER_OF_FOLDS, 1);
    validationAccuracy = zeros(NUMBER_OF_FOLDS, 1);

    for fold = 1:NUMBER_OF_FOLDS

        fprintf('Processing fold: %s\n', num2str(fold));
        dataFileName = strcat(DATA_FILE_NAME_SUBSTRING, num2str(fold), '.mat');
        [trainingAccuracy(fold), validationAccuracy(fold)] = learnKNN(dataFileName, numberOfNeighbors);
        fprintf('Training Set Accuracy: %f\n', trainingAccuracy(fold));
        fprintf('Validation Set Accuracy: %f\n\n', validationAccuracy(fold));
    end

    avgAccuracyTrain = mean(trainingAccuracy);
    avgAccuracyCV = mean(validationAccuracy);
end

