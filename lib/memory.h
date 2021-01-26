#ifndef MEGADEV__MEMORY_H
#define MEGADEV__MEMORY_H

void* memcpy(void* dest, void const* src, unsigned long len);

void* memset (void *dest, int val, unsigned long len);

char* strcpy(char* dest, char const* src);

unsigned int __mulsi3(unsigned int a, unsigned int b);

#endif
