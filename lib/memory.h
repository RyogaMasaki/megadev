#ifndef MEGADEV__MEMORY_H
#define MEGADEV__MEMORY_H

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
#endif
