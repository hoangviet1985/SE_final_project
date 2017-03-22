#include "mex.h"
#include <math.h>
#include <stddef.h>
#include <stdio.h>

void mexFunction ( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[] )
{
    size_t dimX, dimY, dimXr, dimYr, dimXblock, dimYblock, outRows, x, y, colIndex,
           rowIndex, fcell_of_block_x, fcell_of_block_y,
           current_block_x, current_block_y;
    double *ptIn;
    double *ptOut;
    
    dimYr = mxGetM(prhs[0]);
    dimYblock = floor(dimYr/28);
    dimY = dimYblock * 28;
    dimXr = mxGetN(prhs[0]);
    dimXblock = floor(dimXr/28);
    dimX = dimXblock * 28;
    outRows = dimX * dimY / 784;
    plhs[0] = mxCreateNumericMatrix(outRows, 784 , mxDOUBLE_CLASS, mxREAL);
    ptIn = mxGetPr(prhs[0]);
    ptOut = mxGetPr(plhs[0]);
    
    for(x = 0; x < dimX; ++x){
        for(y = 0; y < dimY; ++y){
            current_block_x = floor(x/28);
            current_block_y = floor(y/28);
            rowIndex =  current_block_x * dimYblock + current_block_y;
            fcell_of_block_x = current_block_x * 28;
            fcell_of_block_y = current_block_y * 28;
            colIndex = (x - fcell_of_block_x) * 28 + y - fcell_of_block_y;
            ptOut[colIndex * outRows + rowIndex] = ptIn[x * dimYr + y];
        }
    }     
}