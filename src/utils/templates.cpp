#include <cstring>
#include <fstream>
#include <iostream>
#include <string>
#include <vector>

#include "templates.hpp"

#include "emdata.h"

Templates::Templates(const std::string& path, size_t cnt) : count(cnt) {
  auto tp = std::make_unique<emdata>();
  // read from hdf, read one piece first
  tp->readImage(path.c_str(), 0);
  width = tp->header.nx;
  height = tp->header.ny;
  const size_t size = width * height;
  bytes = size * count * sizeof(float);
  std::printf("image size: (%zu, %zu, %zu), ", width, height, count);

  // allocate once for all
  data = std::make_unique<float[]>(static_cast<size_t>(size * count));
  std::printf("allocated floats: %zu, ", size * count);
  std::memcpy(data.get(), tp->getData(), size * sizeof(float));

  // read all pieces
  for (int i = 1; i < count; ++i) {
    tp->readImage(path.c_str(), i);
    std::memcpy(data.get() + size * i, tp->getData(), size * sizeof(float));
  }
}