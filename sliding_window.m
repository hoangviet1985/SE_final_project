function [result] = sliding_window(img)
    [m, n] = size(img);
    
    %w_sides = 28:28:round(min([m;n])/5,0);
    load('nn/Theta1_digit.mat');
    load('nn/Theta2_digit.mat');
    load('nn/Theta1_cnc.mat');
    load('nn/Theta2_cnc.mat');
    result = [0 0 0 0];
    
    %for i = 1:size(w_sides)
        %scale = 28/w_sides(i);
        for j = 0:28:m-28
            for k = 0:28:n-28
                window = img(j+1:j+28, k+1:k+28);
                %window = imresize(window, scale);
%                 if size(window,1) < 28
%                     padding = zeros(size(window,1), 28-size(window,2));
%                     window = [window padding];
%                     padding = zeros(28-size(window,1), size(window,2));
%                     window = [window; padding];
%                 elseif size(window,1) > 28
%                     window = window(1:28, 1:28);
%                 end
                for l = 0:90:360
                    window_rot = imrotate(window,l,'bilinear','crop');
                    window_rot = reshape(window_rot,1,784);
                    cd nn;
                    res1 = predict(Theta1_cnc, Theta2_cnc, window_rot, 0);
                    cd ..;
                    if res1 == 1
                        cd nn;
                        res = predict(Theta1_digit, Theta2_digit, window_rot, 1);
                        cd ..;
                        result = [result; [res,j,k,28]];
                        break;
                    end
                end
            end
        end
    %end