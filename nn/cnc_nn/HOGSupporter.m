function cells = HOGSupporter(block_struct)
    cell = reshape(block_struct.data, [28 28]);
    kernelX = [-1 0 1];
    kernelY = [-1; 0; 1];
    X = imfilter(cell, kernelX);
    Y = imfilter(cell, kernelY);
    norms = sqrt(X.^2 + Y.^2);
    orients = atand(Y./X);
    cells = zeros(49, 9);
    for i = 1:4:25
        for j = 1:4:25
            if(norms(i,j) > 0)
                cell_loc = (i-1)*7/4 + (j-1)/4 + 1;
                orient = (orients(i, j) + 90) / 20 + 1;
                portion = (orient - floor(orient)) * norms(i, j);
                if orient > 9
                    cells(cell_loc, 9) = cells(cell_loc,9) + portion;
                    cells(cell_loc, 1) = cells(cell_loc,1) + norms(i, j) - portion;
                else
                    fIndex = floor(orient);
                    cIndex = ceil(orient);
                    cells(cell_loc, fIndex) = cells(cell_loc, fIndex) + portion;
                    cells(cell_loc, cIndex) = cells(cell_loc, cIndex) + norms(i, j) - portion;
                end
            end
        end
    end
    cells = reshape(cells, [1, 441]);
    end