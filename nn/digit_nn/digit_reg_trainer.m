
%% Initialization
clear ; close all; clc

input_layer_size  = 784;  % 28x28 Input Images of Digits
hidden_layer_size = 25;   % 25 hidden units
num_labels = 10;          % 10 labels, from 1 to 10   
                          % (note that we have mapped "0" to label 10)

%% =========== Part 1: Loading and Visualizing Data =============

% Load Training Data
fprintf('Loading and Visualizing Data ...\n')

cd ..;
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
cd digit_nn;

fprintf('Program paused. Press enter to continue.\n');
pause;


%% ================ Part 2: Initializing weights ================

fprintf('\nInitializing weight randomly ...\n')

Theta1_digit = randInitializeWeights(input_layer_size, hidden_layer_size);
Theta2_digit = randInitializeWeights(hidden_layer_size, num_labels);

% Merge parameters 
initial_nn_params = [Theta1_digit(:) ; Theta2_digit(:)];
org_initial_nn_params = initial_nn_params;

%% =================== Part 3: Training NN ===================

fprintf('\nTraining Neural Network... \n')

options = optimset('MaxIter', 400);

%  Try different values of lambda
lambda = 2.8;

% Create "short hand" for the cost function to be minimized
costFunction = @(p) nnCostFunction(p, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, X_train, y_train, lambda);

% Now, costFunction is a function that takes in only one argument (the
% neural network parameters)
[nn_params, cost] = fmincg(costFunction, initial_nn_params, options);

% Obtain Theta1 and Theta2 back from nn_params
Theta1_digit = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2_digit = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

fprintf('Program paused. Press enter to continue.\n');
pause;


%% ================= Part 4: Visualize Weights =================

fprintf('\nVisualizing Neural Network... \n')

cd ..;
displayData(Theta1_digit(:, 2:end));
cd digit_nn;

fprintf('\nProgram paused. Press enter to continue.\n');
pause;

%% ================= Part 5: Implement Predict =================
%  After training the neural network, we would like to use it to predict
%  the labels. You will now implement the "predict" function to use the
%  neural network to predict the labels of the training set. This lets
%  you compute the training set accuracy.

pred = predict_digit(Theta1_digit, Theta2_digit, X_test);

fprintf('\nTraining Set Accuracy: %f\n', mean(double(pred == y_test)) * 100);

save Theta1_digit.mat Theta1_digit;
save Theta2_digit.mat Theta2_digit;