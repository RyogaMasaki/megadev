################################################################################
# MEGADEV - Development tools for Mega Drive and Mega CD hardware
# https://github.com/drojaazu/megadev
################################################################################

################################################################################
# PROJECT CONFIGURATION
# Settings with 'MD' and 'CD' are specific to Mega Drive and Mega CD hardware,
# respectively
################################################################################

# This will be used for filename output
PROJECT_NAME=megadev_dev

# Build project in debug mode
DEBUG:=1

TARGET:=md

MEGADEV_PATH:=.

# Resources path
RES_PATH:=res

# Build path, will contain objects during compilation
BUILD_PATH:=build

# Final built output path
DIST_PATH:=dist

# Z80 CPU code path
Z80_SRC_PATH:=z80_src

TOOLS_PATH:=$(MEGADEV_PATH)/tools

# MEGADEV SDK paths
# library (this includes C headers)
LIB_PATH:=$(MEGADEV_PATH)/lib

# build time tools
TOOLS_PATH:=$(MEGADEV_PATH)/tools

# linker scripts
CFG_PATH:=$(MEGADEV_PATH)/cfg

# specify your M68k GNU toolchain prefix
M68K_PREFIX?=m68k-elf-


################################################################################
# You shouldn't need to configure anything further
# for your project below this line
################################################################################

# fancy colors cause we're fancy
CLEAR=\033[0m
RED=\033[1;31m
YELLOW=\033[1;33m
GREEN=\033[1;32m

# NOTE: we assume all commands appear somewhere in PATH.
# If you've manually configured/built some of these
# tools and their directories are not listed in PATH
# you will need to specify the full path of each command

# m68k toolset
CC:=$(M68K_PREFIX)gcc
OBJCPY:=$(M68K_PREFIX)objcopy
NM:=$(M68K_PREFIX)nm
LD:=$(M68K_PREFIX)ld
AS:=$(M68K_PREFIX)as

# z80 toolset
ASM_Z80:=sjasmplus

# setup includes
INC:=-I$(LIB_PATH) -I$(RES_PATH) -I$(BUILD_PATH)
CC_INC:=-Wa,-I$(LIB_PATH)

# default flags
CC_FLAGS:=-m68000 -Wall -Wextra -Wno-shift-negative-value -fno-builtin
#DEF_FLAGS_Z80:=-i$(SRC_DIR) -i$(INC_DIR) -i$(RES_DIR) -i$(LIB_DIR)
AS_FLAGS:=--register-prefix-optional --bitwise-or
LD_FLAGS:=-nostdlib

# debug/final build flags
ifeq ($(DEBUG), 1)
  CC_FLAGS+=-O1 -ggdb -DDEBUG
else
  CC_FLAGS+=-O3 -fno-web -fno-gcse -fno-unit-at-a-time -fomit-frame-pointer
endif

ifeq ($(TARGET), md)
  # MD ROM
  include makefile_md
endif

ifeq ($(TARGET), cd)
  # Mega CD
  include makefile_cd
endif

# gather res files
RES:=$(wildcard $(RES_PATH)/*.res)
RES_SRC:=$(addprefix $(SRC_PATH)/,$(notdir $(RES:.res=.s)))
RES_H:=$(RES_SRC:.s=.h)
RES_OBJ:=$(addprefix $(BUILD_PATH)/,$(RES_SRC:.s=.o))

prebuild:
	@mkdir -p $(BUILD_PATH)/$(SRC_PATH) $(BUILD_PATH)/$(RES_PATH)
	@echo -e "${YELLOW}Beginning $(BUILDTYPE) project build...${CLEAR}"

postbuild:
	@echo -e "${GREEN}Build complete!${CLEAR}"

init:
	@mkdir -p $(SRC_PATH) $(BUILD_PATH)/$(SRC_PATH) $(RES_PATH) $(DIST_PATH)
	

res: $(RES_SRC) $(RES_H) $(RES_OBJ)

clean_res:
	@rm -rf $(RES_OBJ)

$(RES_SRC) $(RES_H): $(RES)
	$(TOOLS_PATH)/makeres.sh $(RES_PATH) $(SRC_PATH)
	
