
%% Initialization
clear ; close all; clc

input_layer_size  = 784;  % 28x28 Input Images of Digits
layer1_size = 100;        % 100 hidden units of layer 1
layer2_size = 25;         % 25 hidden units of layer 2
num_labels = 10;          % 10 labels, from 1 to 10   
                          % (note that we have mapped "0" to label 10)

%% =========== Part 1: Loading and Visualizing Data =============

% Load Training Data
fprintf('Loading and Visualizing Data ...\n')

X_train = loadMNISTImages('train-images.idx3-ubyte');
X_train = X_train';
X_train = double(logical(X_train));
y_train = loadMNISTLabels('train-labels.idx1-ubyte');
temp = y_train == 0;
y_train(temp) = 10;
m = size(X_train, 1);

%load Testing data
X_test = loadMNISTImages('t10k-images.idx3-ubyte');
X_test = X_test';
X_test = double(logical(X_test));
y_test = loadMNISTLabels('t10k-labels.idx1-ubyte');
temp = y_test == 0;
y_test(temp) = 10;

% Randomly select 100 data points from training data set to display
sel = randperm(size(X_train, 1));
sel = sel(1:100);

displayData(X_train(sel, :));

fprintf('Program paused. Press enter to continue.\n');
pause;


%% ================ Part 2: Initializing weights ================

fprintf('\nInitializing weight randomly ...\n')

Theta1_digit_3l = randInitializeWeights(input_layer_size, layer1_size);
Theta2_digit_3l = randInitializeWeights(layer1_size, layer2_size);
Theta3_digit_3l = randInitializeWeights(layer2_size, num_labels);

% Merge parameters 
initial_nn_params = [Theta1_digit_3l(:) ; Theta2_digit_3l(:); Theta3_digit_3l(:)];

%% =================== Part 4: Training NN ===================

fprintf('\nTraining Neural Network... \n')

options = optimset('MaxIter', 400);

%  Try different values of lambda
lambda = 0.1;

% Create "short hand" for the cost function to be minimized
costFunction_3l = @(p) nnCostFunction_3l(p, ...
                                   input_layer_size, ...
                                   layer1_size, ...
                                   layer2_size, ...
                                   num_labels, ...
                                   X_train, ...
                                   y_train, ...
                                   lambda);

% Now, costFunction is a function that takes in only one argument (the
% neural network parameters)
[nn_params, cost] = fmincg(costFunction_3l, initial_nn_params, options);

% Obtain Theta1 and Theta2 back from nn_params
t1_all = layer1_size * (input_layer_size + 1);
Theta1_digit_3l = reshape(nn_params(1:t1_all), ...
                 layer1_size, (input_layer_size + 1));
t2_all = layer2_size * (layer1_size + 1);
Theta2_digit_3l = reshape(nn_params(t1_all + 1: t1_all + t2_all), ...
                 layer2_size, (layer1_size + 1));
             
Theta3_digit_3l = reshape(nn_params(1 + t1_all + t2_all:end), ...
                 num_labels, (layer2_size + 1));

fprintf('Program paused. Press enter to continue.\n');
pause;


%% ================= Part 5: Visualize Weights =================

fprintf('\nVisualizing Neural Network... \n')

displayData(Theta1_digit_3l(:, 2:end));

fprintf('\nProgram paused. Press enter to continue.\n');
pause;

%% ================= Part 8: Implement Predict =================
%  After training the neural network, we would like to use it to predict
%  the labels. You will now implement the "predict" function to use the
%  neural network to predict the labels of the training set. This lets
%  you compute the training set accuracy.

pred = predict_digit_3l(Theta1_digit_3l, Theta2_digit_3l, Theta3_digit_3l, X_test);

fprintf('\nTraining Set Accuracy: %f\n', mean(double(pred == y_test)) * 100);

save Theta1_digit_3l.mat Theta1_digit_3l;
save Theta2_digit_3l.mat Theta2_digit_3l;
save Theta3_digit_3l.mat Theta3_digit_3l;