KNN_NEIGHBOR_VALUES = 1:2:15;
NN_HIDDEN_LAYER_SIZE_VALUES = 15:5:50;
SVM_KERNELS = {'linear'; 'gaussian'; 'polynomial'};

knnTrainAccuracy = zeros(numel(KNN_NEIGHBOR_VALUES), 1);
knnValidationAccuracy = zeros(numel(KNN_NEIGHBOR_VALUES), 1);

nnTrainAccuracy = zeros(numel(NN_HIDDEN_LAYER_SIZE_VALUES), 1);
nnValidationAccuracy = zeros(numel(NN_HIDDEN_LAYER_SIZE_VALUES), 1);

svmTrainAccuracy = zeros(numel(SVM_KERNELS), 1);
svmValidationAccuracy = zeros(numel(SVM_KERNELS), 1);

for n = KNN_NEIGHBOR_VALUES

    [knnTrainAccuracy(n), knnValidationAccuracy(n)] = knnCV(n);
end

for h = NN_HIDDEN_LAYER_SIZE_VALUES

    [nnTrainAccuracy(h), nnValidationAccuracy(h)] = nnCV(h);
end

for k = 1:numel(SVM_KERNELS)
   
    [svmTrainAccuracy(n), svmValidationAccuracy(n)] = svmCV(SVM_KERNELS{k});
end

% Prepare data for plotting
for k = 1:numel(SVM_KERNELS)

    svmBar(k, 1) = svmTrainAccuracy(k);
    svmBar(k, 2) = svmValidationAccuracy(k);
end

for n = 1:numel(KNN_NEIGHBOR_VALUES)

    knnBar(n, 1) = knnTrainAccuracy(n);
    knnBar(n, 2) = knnValidationAccuracy(n);
end

for h = 1:numel(NN_HIDDEN_LAYER_SIZE_VALUES)

    nnBar(h, 1) = nnTrainAccuracy(h);
    nnBar(h, 2) = nnValidationAccuracy(h);
end

% PLOT SVM
figure;
h = bar(1:numel(SVM_KERNELS), svmBar);
grid on
l = cell(1, 2);
l{1} = 'Training';
l{2} = 'CV';
legend(h, l);
title('SVM - Gaussian Kernel');
% xlabel('Kernel Functions');
set(gca, 'xticklabel', SVM_KERNELS)
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
title('2-Layer Neural Network');
xlabel('Number of Neighbors');
ylabel('Accuracy');