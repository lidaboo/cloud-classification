function [trainingAccuracy, validationAccuracy] = learnNN(dataFile, hiddenLayerSize)

    TILE_LENGTH = 30;
    OFFSET = 2;
    LAMBDA = 0;
    NUMBER_OF_LABELS = 2;
    INPUT_LAYER_SIZE = (TILE_LENGTH - 2 * OFFSET) * (TILE_LENGTH - 2 * OFFSET);
    
    [trainX, trainY, valX, valY] = loadData(dataFile);

    % initialize neural network parameters
    hiddenTheta = randInitializeWeights(INPUT_LAYER_SIZE, hiddenLayerSize);
    outputTheta = randInitializeWeights(hiddenLayerSize, NUMBER_OF_LABELS);

    % Unroll parameters
    initialParams = [hiddenTheta(:); outputTheta(:)];

    options = optimset('MaxIter', 400);

    % Create "short hand" for the cost function to be minimized
    costFunction = @(p) nnCostFunction(p, INPUT_LAYER_SIZE, hiddenLayerSize, ...
                                       NUMBER_OF_LABELS, trainX, trainY, LAMBDA);

    % Now, costFunction is a function that takes in only one argument (the neural network parameters)
    [nnParams, ~] = fmincg(costFunction, initialParams, options);

    % Obtain hiddenTheta and outputTheta back from nn_params
    hiddenTheta = reshape(nnParams(1:hiddenLayerSize * (INPUT_LAYER_SIZE + 1)), ...
                                     hiddenLayerSize, (INPUT_LAYER_SIZE + 1));

    outputTheta = reshape(nnParams((1 + (hiddenLayerSize * (INPUT_LAYER_SIZE + 1))):end), ...
                                     NUMBER_OF_LABELS, (hiddenLayerSize + 1));

    pred = predict(hiddenTheta, outputTheta, trainX);
    trainingAccuracy = mean(double(pred == trainY)) * 100;
    
    pred = predict(hiddenTheta, outputTheta, valX);
    validationAccuracy =  mean(double(pred == valY)) * 100;
end

