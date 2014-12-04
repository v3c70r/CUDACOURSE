#include <thrust/host_vector.h> 
#include <thrust/device_vector.h> 
#include <thrust/sort.h>


int main(void)
{
  // generate 16M random numbers on the host
  thrust::host_vector<int> h_vec(1 << 24); 
  thrust::generate(h_vec.begin(), h_vec.end(), rand);
  // transfer data to the device
  thrust::device_vector<int> d_vec = h_vec; // sort data on the device
  thrust::sort(d_vec.begin(), d_vec.end()); // transfer data back to host
  thrust::copy(d_vec.begin(), d_vec.end(), h_vec.begin()); 
  return 0;
}
