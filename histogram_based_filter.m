function [isfail,image] = histogram_based_filter(img)
    [pc,glevel] = imhist(img);%get image's histogram
    glevel_count = [glevel pc];
    num_pixels = sum(pc);
    figure;
    plot(glevel,pc,'b');

    [top, indices] = max(pc);
    tops = glevel_count(indices(1),:);
    left = tops(1,1);
    right = tops(1,1) + 2;
    while left >= 1
        if glevel_count(left,2) > glevel_count(left+1,2)
            if left-1 >= 1
                if glevel_count(left-1,2) < glevel_count(left,2)
                    if glevel_count(left,2) >= tops(1,2)/3
                        tops = [tops;[left-1 glevel_count(left,2)]];
                    end
                end
            elseif glevel_count(left,2) >= tops(1,2)/3
                tops = [tops;[left-1 glevel_count(left,2)]];
            end
        end
        left = left - 1;
    end
    while right <= 256
        if glevel_count(right,2) > glevel_count(right-1,2)
            if right+1 <= 256
                if glevel_count(right,2) < glevel_count(right+1,2)
                    if glevel_count(right,2) >= tops(1,2)/3
                        tops = [tops;[right-1 glevel_count(right,2)]];
                    end
                end
            elseif glevel_count(right,2) >= tops(1,2)/3
                tops = [tops;[right-1 glevel_count(right,2)]];
            end
        end
        right = right + 1;
    end        
    
    isfail = 1;
    white_ranges = [0 0];
    left = tops(1,1)+1;
    right = left;
    threshold = 0.05*top;
    minus = 1;
    while left >= 1
        if left >= 1
            if glevel_count(left,2) > threshold
                left = left - 1;
            else
                minus = 0;
                break;
            end
        end
    end
    left = left + minus;
    minus = 1;
    while right <= 256
        if right <= 256
            if glevel_count(right,2) > threshold
                right = right + 1;
            else
                minus = 0;
                break;
            end
        end
    end
    right = right - minus;
    white_ranges = [white_ranges;[left-1 right-1]];

    for i=2:size(tops,1)
        threshold = 0.1*tops(i,2);
        if tops(i,1) < tops(1,1)
            left_sub = tops(i,1)+1;
            if left_sub >= left
                left_sub = left - 1;
            end
            right_sub = left_sub;
            if left_sub >= 1
                minus = 1;
                while left_sub >= 1
                    if glevel_count(left_sub,2) > threshold 
                        left_sub = left_sub - 1;
                    else
                        minus = 0;
                        break;
                    end
                end
                left_sub = left_sub + minus;
                minus = 1;
                while right_sub < left
                    if glevel_count(right_sub,2) > threshold
                        right_sub = right_sub + 1;
                    else
                        minus = 0;
                        break;
                    end
                end
                right_sub = right_sub - minus;
                if left_sub ~= left
                    white_ranges = [white_ranges;[left_sub-1 right_sub-1]];
                end
                left = left_sub;
            end
        else
            right_sub = tops(i,1)+1;
            if right_sub < right
                right_sub = right;
            end
            left_sub = right_sub;
            if right <= 256
                minus = 1;
                while right_sub <= 256
                    if glevel_count(right_sub,2) > threshold 
                        right_sub = right_sub + 1;
                    else
                        minus = 0;
                        break;
                    end
                end
                right_sub = right_sub - minus;
                minus = 1;
                while left_sub > right
                    if glevel_count(left_sub,2) > threshold
                        left_sub = left_sub - 1;
                    else
                        minus = 0;
                        break;
                    end
                end
                left_sub = left_sub + minus;
                if right_sub ~= right
                    white_ranges = [white_ranges;[left_sub-1 right_sub-1]];
                end
                right = right_sub;
            end
        end
    end

    for i = 1:255
        for j = 2:size(white_ranges,1)
            if glevel(i) >= white_ranges(j,1) && ...
               glevel(i) <= white_ranges(j,2)
                pc(i) = 0;
                break;
            end
        end
    end
    left_pixels = sum(pc);

    if left_pixels/num_pixels > 0.08
        for i = 1:size(img,1)
            for j = 1:size(img,2)
                for k = 2:size(white_ranges,1)
                    if img(i,j)>=white_ranges(k,1) && img(i,j)<=white_ranges(k,2)
                        img(i,j) = 255;
                        break;
                    end
                end
            end
        end
        isfail = 0;
    end
    image = img;
end