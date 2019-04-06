# Custom toolchain directory
M68K_PATH := /usr/bin

# Output binary file
OUTBIN := out.bin

# Local directories
SRCDIR := src
INCDIR := inc
BUILDDIR := build
BINDIR := bin

# Toolchain
CC := $(M68K_PATH)/m68k-elf-gcc
AS := $(M68K_PATH)/m68k-elf-as
LD := $(M68K_PATH)/m68k-elf-ld

AS_FLAGS := --register-prefix-optional -mcpu=68000 -I$(INCDIR)
CC_FLAGS := -c -O -I$(INCDIR)
LD_FLAGS := -T md.ld -nostdlib

SRC_S := $(shell find $(SRCDIR) -type f -name *.s)
SRC_C := $(shell find $(SRCDIR) -type f -name *.c)
OBJ_S := $(patsubst $(SRCDIR)/%,$(BUILDDIR)/%,$(SRC_S:.s=.o))
OBJ_C := $(patsubst $(SRCDIR)/%,$(BUILDDIR)/%,$(SRC_C:.c=.o))

TARGET := $(BINDIR)/$(OUTBIN)

$(TARGET): $(OBJ_S) $(OBJ_C)
	$(LD) $(LD_FLAGS) -o $(BUILDDIR)/unsized.bin $^
	dd if=$(BUILDDIR)/unsized.bin of=$(TARGET) bs=8K conv=sync
	$(RM) $(BUILDDIR)/unsized.bin

$(OBJ_S): $(SRC_S)
	$(AS) $(AS_FLAGS) -o $@ $(SRC_S)

$(OBJ_C): $(SRC_C)
	$(CC) $(CC_FLAGS) -o $@ $(SRC_C)

# Make object code only
obj: $(OBJ_C) $(OBJ_S)

# Clean project
clean:
	$(RM) -r $(BUILDDIR)/* $(TARGET)

#init
init:
	mkdir build
	mkdir bin

