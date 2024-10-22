#pragma once

#include <string>
#include <memory>
#include <vector>

int GetDeviceCount();
void DeviceMemoryUsage();

std::vector<std::pair<int, int>> work_intervals(int first, int last, int processor_count);
void dump(const std::string& filename, void* ptr, size_t batch_size);
