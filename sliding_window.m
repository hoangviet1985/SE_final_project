function r = sliding_window(img, step_size)
    [m, n] = size(img);
    
    w_sides = 28:4:36;
    w_sides = w_sides';
    window_num = size(w_sides,1);
    load('nn/Theta1_digit.mat');
    load('nn/Theta2_digit.mat');
    load('nn/Theta1_cnc.mat');
    load('nn/Theta2_cnc.mat');
    load('nn/epsilon_cnc.mat');
    
%     t = floor(359/angle_step);
%     temp = t * angle_step;
    %angle_arr = 0:angle_step:temp;
    %angle_arr = angle_arr';
    result = zeros(1, 787);
    for i = 1:step_size:floor((min([m,n])-36)/step_size)*step_size
        I = img(i:end, i:end);
        for j = 1:window_num
            I = imresize(I, 28/w_sides(j));
            
            [Im, In] = size(I);
            t1 = floor(Im/28)*28;
            t2 = floor(In/28)*28;
            for k = 1:28:t1
                for l = 1:28:t2
                    Iblock = I(k:k+27, l:l+27);
                    Iblock = reshape(Iblock,[1,784]);
                    Iblock = [w_sides(j) l+i j+i Iblock];
                    result = [result; Iblock];
                end
            end
%             fun = @(block_struct) sw_supporter(block_struct,...
%                                               w_sides(j), i);
%             R = blockproc(I, [28 28], fun, 'PadPartialBlocks', true);
%             R = reshape(R, [], 787);
%             result = [result; R];
        end
    end
    result = result(2:end, :);
    data = result(:, 4: end);
    global pred;
    pred = predict_cnc(Theta1_cnc, Theta2_cnc, epsilon_cnc(1,1), epsilon_cnc(1,2), data);
    result = [pred result(:,1:3)];
    result = result(pred == 1, 2:end);
    data = [pred data];
    data = data(pred == 1, 2:end);
    pred_digit = predict_digit(Theta1_digit, Theta2_digit, data);
    r = [result pred_digit];
end