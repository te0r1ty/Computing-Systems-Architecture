.include "sc_macro_lib.s"
.global main

.data
	X:	.word 	0
	Asize:	.word	0
	Bsize: 	.word	0
		.align	2
	arrayA:	.space	40              
	arrayB: .space 	40
.text
	main:
		li s8 -2147483648
		li s9 2147483647
		li s10 1
		li s11 10
		
		# No arguments
		size_enter
		# Fills the array put in the argument
		array_filler(arrayA)
		# Puts the result of filtering from first argument to the second
		array_analysis(arrayA, arrayB)

	end:
		jal ending_text
		exit


# Prints the arrays			
ending_text:
		lw t2 Asize
		lw t3 Bsize
		la s3 arrayA
		la s4 arrayB
		print_str("Array A: ")
		print_array(s3, t2)
		
		print_str("Array B: ")
		print_array(s4, t3)
		newline
		ret	
