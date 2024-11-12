#pragma once

#include <mufft.h>

mufftHandle MakeFFTPlan(int dim0, int dim1, int size);