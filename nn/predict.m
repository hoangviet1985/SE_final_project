function p = predict(Theta1, Theta2, X, flag)
%PREDICT Predict the label of an input given a trained neural network
%   p = PREDICT(Theta1, Theta2, X) outputs the predicted label of X given the
%   trained weights of a neural network (Theta1, Theta2)

m = size(X, 1);
num_labels = size(Theta2, 1);

p = zeros(size(X, 1), 1);

h1 = sigmoid(double([ones(m, 1) X]) * Theta1');
h2 = sigmoid([ones(m, 1) h1] * Theta2');
if flag == 0
    a = h2(:,1);
    b = h2(:,2);
    p = (a > 0.95) & (b < 0.0001);
    p = uint8(p);
    p(p == 0) = 2;
else
    [dummy, p] = max(h2, [], 2);
end
% =========================================================================
end