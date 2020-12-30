#include "memory.h"

void memcpy(void* dest, void* src, unsigned int n) {
  char* csrc = (char*)src;
  char* cdest = (char*)dest;
  for (unsigned int iter = 0; iter < n; ++iter) {
    csrc[iter] = cdest[iter];
  }
}

char* strcpy(char* dest, char const* src) {
  char temp;
  unsigned long iter = 0;
  do {
    temp = src[iter];
    dest[iter++] = temp;
  } while (temp != 0);

  return dest;
}

unsigned int __mulsi3(unsigned int a, unsigned int b) {
  unsigned int r = 0;
  while (a) {
    if (a & 1) r += b;
    a >>= 1;
    b <<= 1;
  }
  return r;
}

