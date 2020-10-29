#CC := g++
CC := clang++
CFLAGS := -g -Wall -std=c++17

SRCDIR := src
BUILDDIR := build
BINDIR := bin

TARGET := $(BINDIR)/outbin
INC := -I inc

SRCEXT := cpp
SRC := $(shell find $(SRCDIR) -type f -name *.$(SRCEXT))
OBJ := $(patsubst $(SRCDIR)/%,$(BUILDDIR)/%,$(SRC:.$(SRCEXT)=.o))

$(TARGET): $(OBJ)
	@mkdir -p $(BINDIR)
	$(CC) $^ -o $(TARGET)

$(BUILDDIR)/%.o: $(SRCDIR)/%.$(SRCEXT)
	@mkdir -p $(BUILDDIR)
	$(CC) $(CFLAGS) $(INC) -c -o $@ $<

clean:
	$(RM) -r $(BUILDDIR)/* $(TARGET)

init:
	mkdir $(BUILDDIR)
	mkdir $(BINDIR)

