// quick example for integration with C
// make sure to mark symbols in your asm with .global
// and declare them here as extern as well
extern void vblank_wait();

void basicLoop() {
  do {
    vblank_wait();
  } while (1);
  return;
}
