function [ep1, ep2] = find_epsilon_cnc(Theta1, Theta2, X, y)

m = size(X, 1);
epsilon1 = 0.7:0.01:0.97;
epsilon1 = epsilon1';
epsilon2 = 0.001:0.001:0.2;
epsilon2 = epsilon2';
Fscore = zeros(size(epsilon1,1)*size(epsilon2,1),3);

h1 = sigmoid(double([ones(m, 1) X]) * Theta1');
h2 = sigmoid([ones(m, 1) h1] * Theta2');

true_num = sum(y == 1);
for i = 1:size(epsilon1)
    for j = 1:size(epsilon2)
        p = h2(:,1) > epsilon1(i) & h2(:,2) < epsilon2(j);
        p = double(p);
        p(p == 0) = 2;
        true_pos_num = sum(p == 1 & p == y);
        true_PandN_num = sum(p == 1);
        percision = true_pos_num / true_PandN_num;
        recall = true_pos_num / true_num;
        Fscore((i-1)*2+j,:) = [epsilon1(i) epsilon2(j) 2*percision*recall/(percision+recall)];
    end
end
[dummy, row_index_of_max] = max(Fscore, [], 1);
r = Fscore(row_index_of_max(1,3), :);
ep1 = r(1,1);
ep2 = r(1,2);
% =========================================================================
end