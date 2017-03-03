#include "mex.h"

void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
    size_t xDim;
    size_t yDim;
    size_t window_step;
    size_t imgXdim;
    size_t imgYdim;
    double **img;
    size_t w_sides[] = {24, 28, 32, 36, 40, 44};
    
    if (nrhs != 2)
       mexErrMsgTxt("you need to input 1 matrix, and 1 scalars");
    
    if (mxGetM(prhs[0]) < 300 || mxGetN(prhs[0]) < 300)
        mexErrMsgTxt("input dimensions must be at least 300.");
    if (mxGetM(prhs[1]) != 1 || mxGetN(prhs[1]) != 1)
        mexErrMsgTxt("last inputs must be scalars.");
    if (prhs[1] < 1 && !mxIsUint64(prhs[1])
        mexErrMsgTxt("last inputs must be an positive integer.");
    
    yDim = 787;
    window_step = prhs[1];
    imgXdim = mxGetM(prhs[0]);
    imgYdim = mxGetN(prhs[0]);
    img = get_matrix_space(imgXdim, imgYdim);
    inMatPt = mxGetPr(prhs[0]);
    
    img_pt = (double *)mxGetData(img);
    bytes_to_copy = imgXdim * imgYdim * mxGetElementSize(prhs[0]);
    memcpy(img_pt,inMatPt,bytes_to_copy);
    
    
}

double **get_matrix_space(size_t xDim, size_t yDim)
{
   size_t x;
   double **a;
   
   a = (double **) mxCalloc(xDim, sizeof(double *)); // Use mxCalloc instead of calloc
   --a; //Here we offset the pointer for the array of arrays
   a[1] = (double *) mxCalloc(xDim*yDim, sizeof(double)); // Get all of the memory at once
   --a[1]; // Offset the first a[x]
   for(x=2; x<=xDim; x++) // For all of the other a[x] ...
       a[x] = a[x-1] + yDim; // ... each a[x] is the previous one plus the row stride
   return a;
}

void release_matrix_space(double **a, size_t xDim)
{
    mxFree(a[1]+1); // Use mxFree instead of free since we used mxCalloc to allocate
    mxFree(a+1);
} 