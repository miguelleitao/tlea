## -----------------------------------------------------------------------
##   
##   ISEP, Arquitectura de Computadores 2
##
##   This program is free software; you can redistribute it and/or modify
##   it under the terms of the GNU General Public License as published by
##   the Free Software Foundation, Inc., 53 Temple Place Ste 330,
##   Boston MA 02111-1307, USA; either version 2 of the License, or
##   (at your option) any later version; incorporated herein by reference.
##
## -----------------------------------------------------------------------

##
## Makefile for boot samples
##

gcc_ok   = $(shell if gcc $(1) -c -x c /dev/null -o /dev/null 2>/dev/null; \
	           then echo $(1); else echo $(2); fi)

M32     := $(call gcc_ok,-m32,)

CC         = gcc
LD         = ld -m elf_i386
AR	   = ar
NASM	   = nasm
AS	   = as86
LD86	   = ld86
RANLIB	   = ranlib
CFLAGS     = $(M32) -mregparm=3 -DREGPARM=3 -W -Wall -march=i386 -Os -fomit-frame-pointer -Iinclude -D__COM32__
LNXCFLAGS  = -W -Wall -O -g -Iinclude
LNXSFLAGS  = -g
LNXLDFLAGS = -g
SFLAGS     = -D__COM32__ -march=i386
LDFLAGS    = -T lib/com32.ld
OBJCOPY    = objcopy
LIBGCC    := $(shell $(CC) --print-libgcc)
LIBS	   = lib/libutil_com.a lib/libcom32.a $(LIBGCC)

.SUFFIXES: .c .o .elf .c32 .s .bin


all: 	tlea.bin 

disk.img: tlea.bin
	dd if=/dev/zero of=$@ bs=1k count=2k
	dd conv=notrunc if=$< of=$@
	./put_flag.sh $@

run: disk.img
	qemu-system-i386 $<

.PRECIOUS: %.bin
%.bin: %.o
	$(LD86) -d $< -o $@


.PRECIOUS: %.o
%.o: %.S
	$(CC) $(SFLAGS) -c -o $@ $<

.PRECIOUS: %.o
%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

%.o: %.s
	$(AS) $< -o $@

.PRECIOUS: %.elf
%.elf: %.o $(LIBS)
	$(LD) $(LDFLAGS) -o $@ $^

%.c32: %.elf
	$(OBJCOPY) -O binary $< $@

tidy:
	rm -f *.o *.lo *.a *.lst *.elf

clean: tidy
	rm -f *.lss *.c32 *.lnx *.com

spotless: clean
	rm -f *~ \#*

install:	# Don't install samples
