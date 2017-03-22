
%% Initialization
clear ; close all; clc

input_layer_size  = 784;  % 441 features extracted from a sample or 784 inputs
hidden_layer_size = 25;   % 25 hidden units
num_labels = 2;           % 2 labels, from 1 to 2 (1: character, 2: non-character)   
                          % (note that we have mapped "0" to label 10)

%% =========== Part 1: Loading and Visualizing Data =============

% Load Training Data
fprintf('Loading and Visualizing Data ...\n')

cd ..;
X_train = loadMNISTImages('train-images.idx3-ubyte');
cd cnc_nn;
X_train = X_train';
X_train = double(logical(X_train));
%X_train = extractHOGfeatures(X_train);
load('bin_nc.mat');
load('bill_nc.mat');
load('viet_nc.mat');
bin_nc_train = bin_nc(1:70000,:);
%bin_nc_train = extractHOGfeatures(bin_nc_train);
bill_nc_train = bill_nc(1:200000, :);
%bill_nc_train = extractHOGfeatures(bill_nc_train);
%viet_nc = extractHOGfeatures(viet_nc);
X_train = [X_train; bin_nc_train; bill_nc_train; viet_nc];
y_train = [ones(60000,1); ones(270000,1)*2; ones(462,1)*2];
m = size(X_train, 1);

T = [y_train X_train];
T = T(randperm(size(T,1)),:);
X_train = T(:,2:end);
y_train = T(:,1);

%load Testing data
cd ..;
X_test = loadMNISTImages('t10k-images.idx3-ubyte');
cd cnc_nn;
X_test = X_test.';
X_test = double(logical(X_test));
%X_test = extractHOGfeatures(X_test);
bin_nc_test = bin_nc(70001:end,:);
%bin_nc_test = extractHOGfeatures(bin_nc_test);
bill_nc_test = bill_nc(200001:end, :);
%bill_nc_test = extractHOGfeatures(bill_nc_test);
X_test = [X_test; bin_nc_test; bill_nc_test];
y_test = [ones(10000,1); ones(18702,1)*2; ones(21940,1)*2];

T = [y_test X_test];
T = T(randperm(size(T,1)),:);
X_test = T(:,2:end);
y_test = T(:,1);

% Randomly select 100 data points from training data set to display
sel = randperm(size(X_train, 1));
sel = sel(1:100);

cd ..;
displayData(X_train(1:100, :));
cd cnc_nn;

fprintf('Program paused. Press enter to continue.\n');
pause;


%% ================ Part 2: Initializing weights ================

fprintf('\nInitializing weight randomly ...\n')

Theta1_cnc = randInitializeWeights(input_layer_size, hidden_layer_size);
Theta2_cnc = randInitializeWeights(hidden_layer_size, num_labels);

% Merge parameters 
initial_nn_params = [Theta1_cnc(:) ; Theta2_cnc(:)];
org_initial_nn_params = initial_nn_params;

%% =================== Part 3: Training NN ===================

fprintf('\nTraining Neural Network... \n')

options = optimset('MaxIter', 50);

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
Theta1_cnc = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2_cnc = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

fprintf('Program paused. Press enter to continue.\n');
pause;


%% ================= Part 4: Visualize Weights =================

fprintf('\nVisualizing Neural Network... \n')

cd ..;
displayData(Theta1_cnc(:, 2:end));
cd cnc_nn;

fprintf('\nProgram paused. Press enter to continue.\n');
pause;

%% ================= Part 5: Implement Predict =================
%  After training the neural network, we would like to use it to predict
%  the labels. You will now implement the "predict" function to use the
%  neural network to predict the labels of the training set. This lets
%  you compute the training set accuracy.

[ep1, ep2] = find_epsilon_cnc(Theta1_cnc, Theta2_cnc, X_test, y_test);
epsilon_cnc = [ep1, ep2];

pred = predict_cnc_threshold(Theta1_cnc, Theta2_cnc, ep1, ep2, X_test);

fprintf('\nTraining Set Accuracy: %f\n', mean(double(pred == y_test)) * 100);

save Theta1_cnc.mat Theta1_cnc;
save Theta2_cnc.mat Theta2_cnc;
save epsilon_cnc.mat epsilon_cnc;