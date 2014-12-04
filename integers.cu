// includes, system
#include <stdio.h>
#include <assert.h>
#include <stdlib.h> 
 
//WORKSHOP: Change this function to a CUDA kernel
void fillArray(int *data, int N)
{
  int i;
  for( i = 0; i < N; i++)
    {
      data[i] = i;
    }
}

__global__ void fillArray(int *data, int *res)
{
    int idx = threadIdx.x+blockDim.x*blockIdx.x;
    res[idx] = data[idx]+idx;
}
__global__ void fillArrayUnified(int *data )
{
    int idx = threadIdx.x+blockDim.x*blockIdx.x;
    data[idx] = data[idx]+idx;
}
/////////////////////////////////////////////////////////////////////
// Program main
/////////////////////////////////////////////////////////////////////
int main( int argc, char** argv)
{
  //WORKSHOP: Declare data pointers for host and device arrays
  // (not necessary if using Unified memory)
    int *data;
    int i;
    const int N = 100;

 
 /*-----------------------------------------*/
    // allocate host memory
    //data = ( int* ) malloc(N * sizeof(int));
    ////WORKSHOP: Allocate device memory
    //// Remove the host allocation above and use cudaMallocManaged() 
    //// to allocate on host and device if using unified memory
 
    ////Fill the array
    ////WORKSHOP: Change this function call to a CUDA kernel call
    //int *d_data;
    //cudaMalloc(&d_data, sizeof(int)*N);
    //int *d_res;
    //cudaMalloc(&d_res, sizeof(int)*N);
    //cudaMemcpy(d_data, data, sizeof(int)*N, cudaMemcpyHostToDevice);
    ////int blockSize=10;
    //fillArray<<<10,10>>>(d_data, d_res);
    //cudaMemcpy(data, d_res, sizeof(float)*N, cudaMemcpyDeviceToHost);
    //cudaFree(d_res);
    //cudaFree(d_data);




/*-----------Unified memory-----------*/
    cudaMallocManaged(&data, sizeof(int)*N);
    fillArrayUnified<<<10,10>>>(data );
    cudaDeviceSynchronize();

    


    //WORKSHOP: Make sure the device has finished
    //WORKSHOP: Copy the results to the host
    // (not necessary if using unified memory)

    // verify the data is correct
    for (i = 0; i < N; i++)
    {
        assert(data[i] == i );
    }

    
 
    // If the program makes it this far, then the results are
    // correct and there are no run-time errors.  Good work!
    printf("Correct!\n");
 

    //Free by cuda
    cudaFree(data);
    //WORKSHOP: Free the device memory
    // (if using unified memory, you can free the host and device
    //  memory with one cudaFree() call)
    return 0;
}

