#pragma once

#include <memory>
#include <string>

#include "DataReader2.h"

struct Templates {
  Templates() = default;
  Templates(const std::string& path, size_t cnt);

  size_t count;
  size_t width;
  size_t height;
  size_t tall;
  size_t bytes;
  std::unique_ptr<float[]> data;
};