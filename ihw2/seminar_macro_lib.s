# Calculates factorial of %x to fs10 register
.macro fact(%x)
	mv t2 %x
	li t3 1
for:
	mul t3 t3 t2
	addi t2 t2 -1
	bnez t2 for
	fcvt.d.w fs10 t3
.end_macro 


# Calculates  of %x to fs10 register
.macro pow(%x, %y)
	mv t2 %y
	fmv.d fs11 %x
for:
	fmul.d fs11 fs11 %x
	addi t2 t2 -1
	bnez t2 for
.end_macro 


# Calculates exp^(ер%x) 
.macro exp(%x, %y)
	mv s11 %y
	li s10 1
	fcvt.d.w fs1 s10
for:
	pow(%x, s11)
	fact(s11)
	fdiv.d fs9 fs11 fs10
	fadd.d fs1 fs1 fs9
	addi s11 s11 -1
	bnez s11 for
.end_macro 


# Prints the register content as integer
.macro print_int (%x)
	li a7, 1
	mv a0, %x
	ecall
.end_macro


# Prints the register content as integer
.macro print_double (%x)
	li a7, 3
	mv a0, %x
	ecall
.end_macro


# Reads an integer from keyboard to a0 register
.macro read_int_a0
	 li a7, 5
	 ecall
.end_macro


# Reads a double from keyboard to %x register
.macro read_double(%x)
	li a7 7
	ecall
	fmv.d %x fa0
.end_macro 


# Prints the string passed to the macro 
.macro print_str (%x)
.data
	str:	.asciz %x
.text
	push (a0)
	li a7, 4
	la a0, str
	ecall
	pop(a0)
.end_macro


# Literally new line
.macro newline
   	print_char('\n')
.end_macro


# Helping macro
.macro print_char(%x)
	li a7, 11
	li a0, %x
	ecall
.end_macro


# Ends the program
.macro exit
    	li a7, 10
   	ecall
.end_macro


# Pushes the passed register to stack
.macro push(%x)
	addi sp, sp, -4
	sw %x, (sp)
.end_macro


# Pops the last machine word from stack to the passed register
.macro pop(%x)
	lw %x, (sp)
	addi sp, sp, 4
.end_macro
