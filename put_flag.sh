#!/bin/bash
flagfile=flag.bin
if [ $# != 1 ]; then
  echo "Usage $0 device"
  echo 
  exit
fi
if [ ! -f $flagfile ]; then
  echo -n -e '\x55\xAA' > $flagfile
fi
if [ ! -e $1 ]; then
  echo "Error: $1 does not exist."
  echo
  exit
fi
if [ ! -b $1 -a ! -f $1 ]; then
  echo "Error: $1 is valid block file or disk image."
  echo
  exit
fi
if [ ! -w $1 ]; then
  echo "Error: $1 is not writable."
  echo
  exit
fi
dd conv=notrunc if=flag.bin of=$1 bs=1 seek=510 count=2
