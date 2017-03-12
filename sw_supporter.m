function sw_supporter(block_struct, w_side, ration, step_loc, Theta1, Theta2, epsilon1, epsilon2, Theta1_digit, Theta2_digit, Theta3_digit)
    global pred_res; 
    x = round((step_loc + block_struct.location(1, 2))/ration, 0);
    y = round((step_loc + block_struct.location(1, 1))/ration, 0);
    if ~any((pred_res(:, 2) > x-w_side) & (pred_res(:, 3) > y-w_side) &...
            pred_res(:, 1) == w_side)
        d = reshape(block_struct.data, [1, 784]);
        pred = predict_cnc_threshold(Theta1, Theta2, epsilon1, epsilon2, d);
        if pred == 1
            pred_digit = predict_digit_3l(Theta1_digit, Theta2_digit, Theta3_digit, d);
            pred_res = [pred_res; [w_side, x, y, pred_digit]];
        end
    end
end
        