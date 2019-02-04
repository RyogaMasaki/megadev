# Custom toolchain directory
#MD_CHAIN=/opt/md_dev
#MD_BIN=$(MD_CHAIN)/bin
MD_BIN=/usr/bin

# Local directories
SRCDIR := src
INCDIR := inc
BUILDDIR := build
BINDIR := bin

# Toolchain
CC:=$(MD_BIN)/m68k-elf-gcc
AS:=$(MD_BIN)/m68k-elf-as
LD:=$(MD_BIN)/m68k-elf-ld

AS_FLAGS := -m68000 -I$(INCDIR)
CC_FLAGS := -c -O -I$(INCDIR)
LD_FLAGS := -T md.ld -nostdlib

SRC_S := $(shell find $(SRCDIR) -type f -name *.s)
SRC_C := $(shell find $(SRCDIR) -type f -name *.c)
OBJ_S := $(patsubst $(SRCDIR)/%,$(BUILDDIR)/%,$(SRC_S:.s=.o))
OBJ_C := $(patsubst $(SRCDIR)/%,$(BUILDDIR)/%,$(SRC_C:.c=.o))

TARGET := $(BINDIR)/out.bin

$(TARGET): $(OBJ_S) $(OBJ_C)
	$(LD) $(LD_FLAGS) -o $(BUILDDIR)/unsized.bin $^
	dd if=$(BUILDDIR)/unsized.bin of=$(TARGET) bs=8K conv=sync
	$(RM) $(BUILDDIR)/unsized.bin

$(BUILDDIR)/%.o: $(SRC_S) $(SRC_C)
	$(AS) $(AS_FLAGS) -o $@ $(SRC_S)
	$(CC) $(CC_FLAGS) -o $@ $(SRC_C)

#clean
clean:
	$(RM) -r $(BUILDDIR)/* $(TARGET)

#init
init:
	mkdir build
	mkdir bin

