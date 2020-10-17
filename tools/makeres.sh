#!/bin/sh
# Generate asm to include resources
if [ -n "$1" ]
  then
		in_dir="$1"
fi

if [ -n "$2" ]
	then
		out_dir="$2"
fi

# process resources
for resfile in $in_dir/*.res; do
	echo "Processing $resfile..."
	res_file=$(basename $resfile .res)
  res_sfile=$out_dir/$res_file.s
	res_hfile=$out_dir/$res_file.h
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