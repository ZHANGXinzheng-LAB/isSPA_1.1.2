#include <cstdio>
#include <fstream>

#include <cuda_runtime.h>

#include "helper.cuh"

int GetDeviceCount() {
  int devcount{};
  cudaGetDeviceCount(&devcount);
  
  return devcount;
}

void DeviceMemoryUsage() 
{
  size_t free{};
  size_t total{};
  cudaMemGetInfo(&free, &total);
  std::printf("Device total: %zu MB, free: %zu MB, usage: %zu MB\n", total >> 20, free >> 20, (total - free) >> 20);
}

std::vector<std::pair<int, int>> work_intervals(int first, int last, int processor_count) 
{
  std::vector<std::pair<int, int>> ret;
  float total_works = last - first;
  int works_per_processor = std::max(static_cast<int>(std::round(total_works / processor_count)), 1);
  for (int i = 0; i < processor_count && first < last; ++i) {
    ret.push_back({first, std::min(first + works_per_processor, last)});
    first += works_per_processor;
  }
  ret.back().second = last;
  return ret;
}

void dump(const std::string& filename, const void* ptr, size_t size) 
{
  std::fstream output(filename, std::ios::binary | std::ios::out | std::ios::trunc);
  auto pb = reinterpret_cast<const char*>(ptr);
  output.write(pb, size);
}