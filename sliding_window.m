function r = sliding_window(img)
    max_w_side = 44;
    w_sides = 28:4:max_w_side;
    w_sides = w_sides';
    window_num = size(w_sides,1);
    load('nn/digit_nn/Theta1_digit_3l.mat');
    load('nn/digit_nn/Theta2_digit_3l.mat');
    load('nn/digit_nn/Theta3_digit_3l.mat');
    load('nn/cnc_nn/Theta1_cnc.mat');
    load('nn/cnc_nn/Theta2_cnc.mat');
    load('nn/cnc_nn/epsilon_cnc.mat');
    
    global pred_res;
    pred_res = zeros(1, 4);
    for h = 1:window_num
        ration = 28/w_sides(h);
        I = imresize(img, ration);
        fun = @(block_struct) sw_supporter(block_struct,...
                                          w_sides(h),...
                                          ration,...
                                          Theta1_cnc,...
                                          Theta2_cnc,...
                                          epsilon_cnc(1,1),...
                                          epsilon_cnc(1,2),...
                                          Theta1_digit_3l,...
                                          Theta2_digit_3l,...
                                          Theta3_digit_3l);
        blockproc(I, [10 10], fun, 'PadPartialBlocks', true, 'BorderSize', [9 9], 'TrimBorder', false);
    end
    r = pred_res(2:end, :);
end