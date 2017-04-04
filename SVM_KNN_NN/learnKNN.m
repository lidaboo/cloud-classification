function [trainingAccuracy, validationAccuracy] = learnKNN(dataFileName, numberOfNeighbors)

    [trainX, trainY, valX, valY] = loadData(dataFileName);
    knnModel = fitcknn(trainX, trainY, 'NumNeighbors', numberOfNeighbors);

    predictions = predict(knnModel, trainX);
    trainingAccuracy = mean(double(predictions == trainY)) * 100;

    predictions = predict(knnModel, valX);
    validationAccuracy = mean(double(predictions == valY)) * 100;
end
