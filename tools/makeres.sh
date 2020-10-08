#!/bin/sh
# Generate asm to include resources
echo $BUILD_PATH

if [ -n "$1" ]
  then
		cd "$1"
fi

# process resources
for resfile in *.res; do
	res_file=$(basename $resfile .res)
  res_sfile=$res_file.s
	res_hfile=$res_file.h
	# asm source file
	echo ".section .rodata" > $res_sfile
	echo >> $res_sfile
	# C header file
	echo "// $res_hfile" > $res_hfile
	echo -n "#ifndef " >> $res_hfile
	echo "${res_file}__RES_H" | tr [a-z] [A-Z] >> $res_hfile
	echo -n "#define " >> $res_hfile
	echo "${res_file}__RES_H" | tr [a-z] [A-Z] >> $res_hfile
	echo >> $res_hfile
	while read -r thisresfile; do
		thisres=${thisresfile//\./\_}
	  echo ".global $thisres" >> $res_sfile
		echo "$thisres:" >> $res_sfile
		echo "  .incbin \"$thisresfile\"" >> $res_sfile
		echo "  .align 2" >> $res_sfile
		echo >> $res_sfile
		echo "extern void *$thisres;" >> $res_hfile
	done < $resfile
	echo >> $res_hfile
	echo "#endif" >> $res_hfile
done
