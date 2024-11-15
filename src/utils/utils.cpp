#include "utils.h"

// return a random number between lo and hi
float frand(float lo, float hi) {
  static int f = 1;

  if (f) {
    srandom(time(0));
    f = 0;
  }

  return ((float)random() / 2147483647.0 * (hi - lo) + lo);
}

float grand(float mean, float sigma) {
  float x, y, r, f;

  do {
    x = frand(-1.0, 1.0);
    y = frand(-1.0, 1.0);
    r = x * x + y * y;
  } while (r > 1.0 || r == 0);
  f = sqrt(-2.0 * log(r) / r);

  return x * f * sigma + mean;
}

bool is_little_endian() {  // check if this machine is little endian
  int one = 1;
  char *bytep = (char *)(&one);
  if (bytep[0] == 1 && bytep[1] == 0 && bytep[2] == 0 && bytep[3] == 0)
    return true;
  else
    return false;
}

bool is_big_endian() 
{  // check if this machine is big endian
    return !is_little_endian();
}
