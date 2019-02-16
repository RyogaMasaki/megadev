// quick example for integration with C
// make sure to mark symbols in your asm with .global
// and declare them here as extern as well
extern void waitVBlank();

void basicLoop() {
  do {
    waitVBlank();
  } while (1);
  return;
}