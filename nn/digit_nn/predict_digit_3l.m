function p = predict_digit_3l(Theta1, Theta2, Theta3, X)
%PREDICT Predict the label of an input given a trained neural network
%   p = PREDICT_DIGIT(Theta1, Theta2, Theta3, X) outputs the predicted label of X given the
%   trained weights of a neural network (Theta1, Theta2, Theta3)

m = size(X, 1);

h1 = sigmoid(double([ones(m, 1) X]) * Theta1');
h2 = sigmoid([ones(m, 1) h1] * Theta2');
h3 = sigmoid([ones(m, 1) h2] * Theta3');
[dummy, p] = max(h3, [], 2);
% =========================================================================
end