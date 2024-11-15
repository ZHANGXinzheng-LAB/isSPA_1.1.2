#pragma once

#include <cufft.h>

mufftHandle MakeFFTPlan(int dim0, int dim1, int size);