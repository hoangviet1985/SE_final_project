function [issucess,image] = histogram_based_filter(img)
    [pc,glevel] = imhist(img);%get image's histogram
    glevel_count = [glevel pc];
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
                tops = [tops;[left-1 glevel_count(left+1,2)]];
            end
        end
        left = left - 1;
    end
    while right <= 255
        if glevel_count(right,2) > glevel_count(right-1,2)
            if right+1 <= 255
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

    if size(tops,1) <= 5
        white_ranges = [0 0];
        for i=1:size(tops,1)
            if tops(i,2)==top
                threshold = 0.05*tops(i,2);
            else
                threshold = 0.1*tops(i,2);
            end
            left = glevel_count(tops(i,1)+1,1);
            right = left;
            while left>=0 || right<=255
                if left>=0
                    if glevel_count(left+1,2) > threshold
                        left = left - 1;
                    end
                end
                if right<=255
                    if glevel_count(right+1,2) > threshold
                        right = right + 1;
                    end
                end
                if left>=0 && right<=255
                    if glevel_count(left+1,2)<=threshold && glevel_count(right+1,2)<=threshold
                        break;
                    end
                elseif right > 255 && glevel_count(left+1,2)<=threshold
                    break;
                elseif left < 0 && glevel_count(right+1,2)<=threshold
                    break;
                end
            end
            if left < 0
                left = 0;
            end
            if right > 255
                right = 255;
            end
            white_ranges = [white_ranges;[left right]];
        end
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
        issucess = 0;
    else
        issucess = 1;
    end
    image = img;
end