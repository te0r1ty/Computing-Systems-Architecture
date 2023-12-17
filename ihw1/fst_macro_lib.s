# Prints the register content as integer
.macro print_int (%x)
		li a7, 1
		mv a0, %x
		ecall
.end_macro

# Reads an integer from keyboard to a0 register
.macro read_int_a0
		 li a7, 5
		 ecall
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
