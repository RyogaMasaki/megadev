# Custom toolchain directory
MD_CHAIN=/opt/md_dev/binutils
MD_BIN=$(MD_CHAIN)/bin

# Local directories
SRCDIR := src
INCDIR := inc
BUILDDIR := build
BINDIR := bin

# Toolchain
CC:=$(MD_BIN)/m68k-elf-gcc
AS:=$(MD_BIN)/m68k-elf-as
LD:=$(MD_BIN)/m68k-elf-ld
OBJC:=$(MD_BIN)/m68k-elf-objcopy 

AS_FLAGS := -m68000 -I$(INCDIR)
LD_FLAGS := --oformat=binary -T md.ld -nostdlib 

SRC := $(shell find $(SRCDIR) -type f -name *.s)
OBJ := $(patsubst $(SRCDIR)/%,$(BUILDDIR)/%,$(SRC:.s=.o))

TARGET := $(BINDIR)/out.bin

$(TARGET): $(OBJ)
	$(LD) $(LD_FLAGS) -o $(BUILDDIR)/unsized.bin $^
	dd if=$(BUILDDIR)/unsized.bin of=$(TARGET) bs=8K conv=sync
	$(RM) $(BUILDDIR)/unsized.bin

#compile assembly files
$(BUILDDIR)/%.o: $(SRC)
	$(AS) $(AS_FLAGS) -o $@ $^

#compile c files

#clean
clean:
	$(RM) -r $(BUILDDIR)/* $(TARGET)

#init
init:
	mkdir build
	mkdir bin

