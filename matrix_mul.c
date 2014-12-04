#include<stdio.h>
#include<stdlib.h>
#include<time.h>
#define SIZE 4000
float a[SIZE][SIZE];
float b[SIZE][SIZE];
float c[SIZE][SIZE];
float seq[SIZE][SIZE];
 
void checkResult()
{
  int i, j, k;
  // ****************
  // double-check the result sequentially on the host
  // ****************
  // Initialize the seq matrix
  for(i = 0; i < SIZE; ++i)
    for(j = 0; j < SIZE; ++j)
      seq[i][j] = 0.f;
   
  // Perform the multiplication
  for (i = 0; i < SIZE; ++i)
    for (j = 0; j < SIZE; ++j)
      for (k = 0; k < SIZE; ++k)
	seq[i][j] += a[i][k] * b[k][j];
   
  // check all the OpenACC matrices
  for (i = 0; i < SIZE; ++i)
    for (j = 0; j < SIZE; ++j)
      if(c[i][j] != seq[i][j]) {
	printf("Error %d %d\n", i,j);
	exit(1);
      }
 
}

int main()

{
	int i,j,k;
	clock_t start, stop;   
	// Initialize matrices.
	for (i = 0; i < SIZE; ++i) {
		for (j = 0; j < SIZE; ++j) {
			a[i][j] = (float)i + j;
			b[i][j] = (float)i - j;
			c[i][j] = 0.0f;
		}
	}

	start = clock();
	// Compute matrix multiplication.
	//
	for (i = 0; i < SIZE; ++i) {
		for (j = 0; j < SIZE; ++j) {
			for (k = 0; k < SIZE; ++k) {
				c[i][j] += a[i][k] * b[k][j];
			}
		}
	}
	stop = clock();
	//  checkResult();

	printf("matrix multiplication completed! Matrix size = %d\n", SIZE);
	printf("Time required: %f s\n", (double) (stop - start) / CLOCKS_PER_SEC); 

	return 0;
}
