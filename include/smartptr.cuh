#include <musa_runtime.h>

template <typename T>
struct pinned_unique_ptr_deleter {
  void operator()(std::remove_extent_t<T>* ptr) {
    musaFreeHost(ptr);
  }
};

template <typename T>
auto make_host_unique_pinned(size_t num) {
  std::remove_extent_t<T>* ptr;
  musaHostAlloc(&ptr, sizeof(std::remove_extent_t<T>) * num, musaHostAllocDefault);
  return std::unique_ptr<T, pinned_unique_ptr_deleter<T>>(ptr, pinned_unique_ptr_deleter<T>());
}

template <typename T>
using pinned_unique_ptr = std::unique_ptr<T, pinned_unique_ptr_deleter<T>>;

template <typename T>
struct device_unique_ptr_deleter {
  void operator()(std::remove_extent_t<T>* ptr) {
    musaFree(ptr);
  }
};

template <typename T>
auto make_device_unique(size_t num) 
{
  std::remove_extent_t<T>* ptr;
  musaMalloc(&ptr, sizeof(std::remove_extent_t<T>) * num);
  return std::unique_ptr<T, device_unique_ptr_deleter<T>>(ptr, device_unique_ptr_deleter<T>());
}

template <typename T>
using device_unique_ptr = std::unique_ptr<T, device_unique_ptr_deleter<T>>;