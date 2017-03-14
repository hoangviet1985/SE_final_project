function p = predict_cnc(Theta1, Theta2, X)
%PREDICT Predict the label of an input given a trained neural network
%   p = PREDICT_CNC(Theta1, Theta2, epsilon1, epsilon2, X) outputs the predicted label of X given the
%   trained weights of a neural network (Theta1, Theta2)

m = size(X, 1);


h1 = sigmoid(double([ones(m, 1) X]) * Theta1');
h2 = sigmoid([ones(m, 1) h1] * Theta2');
[dummy, p] = max(h2, [], 2);
% =========================================================================
end