function [J, grad] = nnCostFunction_3l(nn_params, ...
                                   input_layer_size, ...
                                   layer1_size, ...
                                   layer2_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a three layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, layer1_size, layer2_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1, Theta2, and Theta3 the weight matrices
% for our 3 layer neural network
Theta1 = reshape(nn_params(1:layer1_size * (input_layer_size + 1)), ...
                 layer1_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (layer1_size * (input_layer_size + 1))):layer2_size * (layer1_size + 1)), ...
                 layer2_size, (layer1_size + 1));
             
Theta3 = reshape(nn_params((1 + (layer2_size * (layer1_size + 1))):end), ...
                 num_labels, (layer2_size + 1));


m = size(X, 1);


X = [ones(size(X,1),1) X];
a2 = sigmoid(X*Theta1.');
a2 = [ones(size(a2, 1), 1) a2];
a3 = sigmoid(a2*Theta2.');
a3 = [ones(size(a3, 1), 1) a3];
a4 = sigmoid(a3*Theta3.');
tempY = zeros(m, num_labels);
for i = 1:m
    tempY(i, y(i)) = 1;
end
temp1 = tempY.*log(a4)+(1.-tempY).*log(1.-a4);
temp1 = sum(sum(temp1, 1));
J = (-1/m)*temp1 + (lambda/2/m) * ...
    (sum(sum(Theta1(:,2:size(Theta1,2)).^2, 2)) + ... 
    sum(sum(Theta2(:,2:size(Theta2,2)).^2, 2)) + ...
    sum(sum(Theta3(:,2:size(Theta3,2)).^2, 2)));
delta4 = a4 - tempY;
delta3 = delta4*Theta3.*a3.*(1.-a3);
delta2 = delta3*Theta2.*a2.*(1.-a2);
Theta1_grad = (1/m)*delta2(:,2:size(delta2,2)).'*X;
Theta1_grad(:,2:size(Theta1_grad,2)) = Theta1_grad(:,2:size(Theta1_grad,2))+(lambda/m)*Theta1(:,2:size(Theta1,2));
Theta2_grad = (1/m)*delta3(:,2:size(delta3,2)).'*a2;
Theta2_grad(:,2:size(Theta2_grad,2)) = Theta2_grad(:,2:size(Theta2_grad,2))+(lambda/m)*Theta2(:,2:size(Theta2,2));
Theta3_grad = (1/m)*delta4.'*a3;
Theta3_grad(:,2:size(Theta3_grad,2)) = Theta3_grad(:,2:size(Theta3_grad,2))+(lambda/m)*Theta3(:,2:size(Theta3,2));

% Unroll gradients
grad = [Theta1_grad(:) ;Theta2_grad(:); Theta3_grad(:)];


end