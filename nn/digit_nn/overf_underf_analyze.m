% Load Training Data
fprintf('Loading Data ...\n')

X_train_and_cv = loadMNISTImages('../train-images.idx3-ubyte');
X_train_and_cv = X_train_and_cv.';
X_train = X_train_and_cv(1:50000,:);
X_cv = X_train_and_cv(50001:end,:);
y_train_and_cv = loadMNISTLabels('../train-labels.idx1-ubyte');
temp = y_train_and_cv == 0;
y_train_and_cv(temp) = 10;
y_train = y_train_and_cv(1:50000);
y_cv = y_train_and_cv(50001:end);
m = size(X_train, 1);

%load Testing data
X_test = loadMNISTImages('../t10k-images.idx3-ubyte');
X_test = X_test.';
y_test = loadMNISTLabels('../t10k-labels.idx1-ubyte');
temp = y_test == 0;
y_test(temp) = 10;


fprintf('\nInitializing weight randomly ...\n')
cd ..;
Theta1 = randInitializeWeights(input_layer_size, hidden_layer_size);
Theta2 = randInitializeWeights(hidden_layer_size, num_labels);
cd digit_nn;
% Merge parameters 
initial_nn_params = [Theta1(:) ; Theta2(:)];
org_initial_nn_params = initial_nn_params;

% Analyze overfitting and underfitting using training data set and cross
% validation data set

fprintf('\nAnalyze overfitting and underfitting... \n')

lambdas = 0:0.1:6;
lambdas = lambdas.';
X_train_mini = X_train(1:5000,:);
y_train_mini = y_train(1:5000);
J_train = zeros(size(lambdas));
J_cv = zeros(size(lambdas));

options = optimset('MaxIter', 400);
for i=1:size(lambdas)
    costFunct_train = @(p) nnCostFunction(p, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, X_train_mini, y_train_mini, lambdas(i));
    [nn_params, cost_train] = fmincg(costFunct_train, initial_nn_params, options);
    J_train(i) = cost_train(end);
    J_cv(i) = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X_cv, y_cv, lambdas(i));
    initial_nn_params = org_initial_nn_params;
end
save Js_train.mat J_train
save Js_cv.mat J_cv
plot(lambdas,J_train,'b',lambdas,J_cv,'r');