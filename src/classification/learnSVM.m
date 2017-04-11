function [trainingAccuracy, validationAccuracy] = learnSVM(dataFileName, kernelFunction)

    [trainX, trainY, valX, valY] = loadData(dataFileName);
    svmModel = fitcsvm(trainX, trainY, 'KernelFunction', kernelFunction);

    predictions = predict(svmModel, trainX);
    trainingAccuracy = mean(double(predictions == trainY)) * 100;

    predictions = predict(svmModel, valX);
    validationAccuracy = mean(double(predictions == valY)) * 100;
end
