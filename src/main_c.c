// quick example for integration with C
extern void waitVBlank();

void main() {
  do {
    waitVBlank();
  } while (1);
  return;
}