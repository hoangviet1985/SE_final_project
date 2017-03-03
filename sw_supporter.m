function r = sw_supporter(block_struct, w_side, step_loc)
        d = reshape(block_struct.data, [1, 784]);
        x = step_loc + block_struct.location(1, 2);
        y = step_loc + block_struct.location(1, 1); 
        r = [w_side x y d];
end
        