# Set this to your MegaDrive dev toolchain directory
MD_CHAIN=/opt/md_dev
MD_BIN=$(MD_CHAIN)/binutils/bin

AS=$(MD_BIN)/m68k-elf-as
LD=$(MD_BIN)/m68k-elf-ld
OBJC=$(MD_BIN)/m68k-elf-objcopy 

AS_FLAGS=-m68000 -Iinc
LD_FLAGS=--oformat=binary -T md.ld -Map=output.map -nostdlib 

INCS=-I. -Iinc

#	# $(OBJC) -O binary $< temp.bin
	#dd if=temp.bin of=$@ bs=8K conv=sync

%.bin: *.s
	$(AS) $(AS_FLAGS) $^ -o temp
	$(LD) $(LD_FLAGS) -o $@ temp
	rm -f temp
