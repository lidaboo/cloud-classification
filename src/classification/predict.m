function predictionIndexes = predict(hiddenTheta, outputTheta, X)
%Predicts the label of an input given a trained neural network

    testSetSize = size(X, 1);    
    X = [ones(testSetSize, 1) X];   % add intercept term to X
    
    hiddenLayer = sigmoid(X * hiddenTheta');
    hiddenLayer = [ones(testSetSize, 1) hiddenLayer];   % add intercept term to the hidden layer
    
    predictions = sigmoid(hiddenLayer * outputTheta');
    [~, predictionIndexes] = max(predictions, [], 2);
end

