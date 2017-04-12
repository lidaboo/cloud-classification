function W = randInitializeWeights(inputSize, outputSize)
%Randomly initializes the weights of a layer with inputSize incoming connections and outputSize outgoing connections

    % Randomly initialize the weights to small values
    initialEpsilon = 0.12;
    W = rand(outputSize, inputSize + 1) * 2 * initialEpsilon - initialEpsilon;
end
