
# tlea - Test LEA instruction

Intel 8086 processor includes the instruction:

	LEA = Load Efective Address

This testing program tries to compare the __LEA__ behaviour with the 
also available __MOV__ instruction.

## Requires

AS86 and QEMU

## Usage

	make
	make	run
	
__make__ builds a binary file.

__make run__ creates a disk image file and boots __qemu__ from it.

Prints to console:

	CS
	IP

	MOV msg
	LEA msg
	DS

	MOV msg'
	LEA msg'
	DS'
	
A less relevant 32 bit experiment is also included. This experiment can be run directly in the Linux OS.

	make
	make run32

## Result
__LEA == MOV__

__LEA__ and __MOV__ instructions produce the same result.
As proved, none of these instructions depend on the __DS__ register.
When loading addresses from location labels in AS86 assembler, 
the results of both instructions are affected by ORG locations, 
as expected.

## Additional notes

NASM assembler does not accept the sintax:

	lea	ax, label_name

This produces "error: invalid combination of opcode and operands"
Instead, NASM accepts:

	lea	ax, [label_name]

This syntax is confusing since this form of __LEA__ instruction does imediate data loading.
It does not access memory.
When using NASM, 

	lea	ax, [label_name]

is the same as 

	mov	ax, label_name

and very different from

	mov	ax, [label_name]

On 8086 (16 bit) the __LEA__ is coded in 4 bytes and the 16 bit imediate __MOV__ is coded in 3 bytes.


