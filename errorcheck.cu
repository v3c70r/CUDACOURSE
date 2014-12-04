//errorcheck.cu - The program is designed to produce output 'data = 7'
//however, errors have been intentionally placed in the program 
//as an error checking exercise. 
#include <stdio.h>
#include <stdlib.h>

__global__ void setData(int *ptr)
{
  *ptr = 7;
}

void checkError(const char *info="")
{
    cudaError_t error = cudaGetLastError();
    if (error != cudaSuccess)
    {
        printf("CUDA error at %s: %s\n", info, cudaGetErrorString(error));
        exit(0);
    }
}


int main(void)
{
    

    int *data_d = 0;
    int *data_h = 0;
    cudaError_t error;


    error = cudaMalloc((void**)&data_d, 1*sizeof(int));
    if (error != cudaSuccess)
    {
        printf("pos1 CUDA error: %s\n", cudaGetErrorString(error));
    }
    data_h = (int *)malloc(sizeof(int));

    setData<<<1,1>>>(data_d);

    checkError("malloc");
    cudaMemcpy(data_h, data_d, sizeof(int), cudaMemcpyDeviceToHost);

    checkError("memcpy");
    printf("data = %d\n", *data_h);
    free(data_h);
    cudaFree(data_d);

    checkError("free memory");

    return 0;

}
