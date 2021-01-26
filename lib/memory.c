/**
 * Implementations mostly copied from GCC
 */

#include "memory.h"

/*
void* memcpy (void *dest, void const* src, unsigned long len)
{
  char *c_dest = dest;
  const char *c_src = src;
  while (len--)
    *c_dest++ = *c_src++;
  return c_dest;
}

void* memset (void *dest, int val, unsigned long len)
{
  unsigned char *ptr = dest;
  while (len-- > 0)
    *ptr++ = val;
  return dest;
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
*/

// TODO: move this into its own file
// or better yet, find a way to make this unnecessary
unsigned int __mulsi3(unsigned int a, unsigned int b) {
  unsigned int r = 0;
  while (a) {
    if (a & 1) r += b;
    a >>= 1;
    b <<= 1;
  }
  return r;
}

