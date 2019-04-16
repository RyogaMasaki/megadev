# Custom toolchain directory
M68K_PATH := /usr/bin

# Output binary file
OUTBIN := out.md
OUTELF := out.elf

# Local directories
SRCDIR := src
SYSDIR := sys
BUILDDIR := build
OUTDIR := bin

# Toolchain
CC := $(M68K_PATH)/m68k-elf-gcc
AS := $(M68K_PATH)/m68k-elf-as
LD := $(M68K_PATH)/m68k-elf-ld

AS_FLAGS := -g --register-prefix-optional -mcpu=68000 -I$(SYSDIR)
CC_FLAGS := -g -c -O -I$(SYSDIR)
LD_FLAGS := -T md.ld -nostdlib

SRC_S := $(shell find $(SRCDIR) -type f -name *.s)
SRC_C := $(shell find $(SRCDIR) -type f -name *.c)
OBJ_S := $(patsubst $(SRCDIR)/%,$(BUILDDIR)/%,$(SRC_S:.s=.o))
OBJ_C := $(patsubst $(SRCDIR)/%,$(BUILDDIR)/%,$(SRC_C:.c=.o))

BINTARGET := $(OUTDIR)/$(OUTBIN)
ELFTARGET := $(OUTDIR)/$(OUTELF)

$(BINTARGET): $(OBJ_S) $(OBJ_C)
	$(LD) $(LD_FLAGS) --oformat binary -o /dev/stdout $^ | dd of=$(BINTARGET) bs=8K conv=sync status=none

$(ELFTARGET): $(OBJ_S) $(OBJ_C)
	$(LD) $(LD_FLAGS) -o $(ELFTARGET) $^

$(OBJ_S): $(SRC_S)
	$(AS) $(AS_FLAGS) -o $@ $(SRC_S)

$(OBJ_C): $(SRC_C)
	$(CC) $(CC_FLAGS) -o $@ $(SRC_C)

# Create Megadrive binary
bin: $(BINTARGET)

# Create ELF binary with debugging symbols
elf: $(ELFTARGET)

all: $(BINTARGET) $(ELFTARGET)

# Clean project
clean:
	$(RM) -r $(BUILDDIR)/* $(BINTARGET) $(ELFTARGET)

#init
init:
	mkdir build
	mkdir bin

