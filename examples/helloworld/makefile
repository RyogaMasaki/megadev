################################################################################
# MEGADEV - Development tools for Sega Mega CD hardware
# https://github.com/drojaazu/megadev
################################################################################

# Path to the Megadev directory
MEGADEV_PATH:=/home/ryou/Projects/megadev

# This will be used for filename output
PROJECT_NAME=helloworld

# the path to your source code
# (relative to the location of the makefile)
SRC_PATH:=src

# Build project in debug mode
DEBUG:=1

# Resources path
# This is where graphics, audio and any other non-code content should be
# stored.
RES_PATH:=res

# Output path
# This will be the location of the final output ISO, as well as the build
# work directory
OUT_PATH:=build

# Disc path 
# This will contain all the files to be included in the final ISO
# You can include any extra files you'd like here
DISC_PATH:=disc

# Memory resident modules
# This is a list of modules which may remain in memory and which may be used
# by other running code as a sort of "library." As such, they need to be built
# first so they can be referenced by other modules.
# Include the base name of each module only (e.g. ipx.def/ipx.mmd -> ipx)
MMD_MR:=

# Optional compiler flags
# Here you can add any additional compiler flags
OPT_FLAGS:=-fstack-usage -fconserve-stack

# Z80 CPU code path
# Z80 building is not currently supported... someday!
#Z80_SRC_PATH:=z80_src

include $(MEGADEV_PATH)/megadev_global
