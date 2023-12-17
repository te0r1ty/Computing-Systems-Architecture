.include "pp.s"
.global main

.data
		.align	2
	array:  .space	40              
	arrend:
	
.text
	main:
		li s8 -2147483648
		li s9 2147483647
		li s10 1
		li s11 10
		
		print_str("¬ведите размер массива от 1 до 10 включительно.\n")
		size_enter
		mv t2 a0
		
		la t0 array
		li s11 1
		array_filler
	
		la t0 array
		li s11 0
		array_analysis
	
	
	bad_end:
		print_str("ѕереполнение :(\n")
		addi t2 t2 -1
	good_end:	
		ending_text
		exit
