KNN_NEIGHBOR_VALUES = 1:2:15;
NN_HIDDEN_LAYER_SIZE_VALUES = 15:5:50;
SVM_KERNELS = {'linear'; 'rbf'; 'polynomial'};

knnTrainAccuracy = zeros(numel(KNN_NEIGHBOR_VALUES), 1);
knnValidationAccuracy = zeros(numel(KNN_NEIGHBOR_VALUES), 1);

nnTrainAccuracy = zeros(numel(NN_HIDDEN_LAYER_SIZE_VALUES), 1);
nnValidationAccuracy = zeros(numel(NN_HIDDEN_LAYER_SIZE_VALUES), 1);

svmTrainAccuracy = zeros(numel(SVM_KERNELS), 1);
svmValidationAccuracy = zeros(numel(SVM_KERNELS), 1);

for n = KNN_NEIGHBOR_VALUES

	fprintf('KNN Cross Validation for %s neighbors\n', num2str(n));
    [knnTrainAccuracy(n), knnValidationAccuracy(n)] = knnCV(n);
end

for h = NN_HIDDEN_LAYER_SIZE_VALUES

    fprintf('NN Cross Validation for hidden layer size: %s\n', num2str(h));
    [nnTrainAccuracy(h), nnValidationAccuracy(h)] = nnCV(h);
end

for k = 1:numel(SVM_KERNELS)
   
    fprintf('SVM Cross Validation for %s kernel function\n', SVM_KERNELS{k});
    [svmTrainAccuracy(k), svmValidationAccuracy(k)] = svmCV(SVM_KERNELS{k});
end

save('results.mat', 'knnTrainAccuracy', 'knnValidationAccuracy', ...
                    'nnTrainAccuracy', 'nnValidationAccuracy', ...
                    'svmTrainAccuracy', 'svmValidationAccuracy');
% Prepare data for plotting
for k = 1:numel(SVM_KERNELS)

    svmBar(k, 1) = svmTrainAccuracy(k);
    svmBar(k, 2) = svmValidationAccuracy(k);
end

for n = KNN_NEIGHBOR_VALUES

    knnBar((n + 1) / 2, 1) = knnTrainAccuracy(n);
    knnBar((n + 1) / 2, 2) = knnValidationAccuracy(n);
end

for h = NN_HIDDEN_LAYER_SIZE_VALUES

    nnBar((h - 10) / 5, 1) = nnTrainAccuracy(h);
    nnBar((h - 10) / 5, 2) = nnValidationAccuracy(h);
end

% PLOT SVM
figure;
h = bar(1:numel(SVM_KERNELS), svmBar);
grid on
l = cell(1, 2);
l{1} = 'Training';
l{2} = 'CV';
legend(h, l);
title('SVM');
% xlabel('Kernel Functions');
set(gca, 'xticklabel', {'LINEAR'; 'RBF'; 'POLYNOMIAL (3rd Order)'});
set(gca, 'ytick', 0:2:100);
ylabel('Accuracy');

% PLOT KNN
figure;
h = bar(KNN_NEIGHBOR_VALUES, knnBar);
grid on
l = cell(1, 2);
l{1} = 'Training';
l{2} = 'CV';
legend(h, l);
title('KNN');
set(gca, 'ytick', 0:2:100);
xlabel('Number of Neighbors');
ylabel('Accuracy');

% PLOT NN
figure;
h = bar(NN_HIDDEN_LAYER_SIZE_VALUES, nnBar);
grid on
l = cell(1, 2);
l{1} = 'Training';
l{2} = 'CV';
legend(h, l);
title('2-Layer Perceptron');
set(gca, 'ytick', 0:2:100);
xlabel('Number of Neurons Inside Hidden Layer');
ylabel('Accuracy');