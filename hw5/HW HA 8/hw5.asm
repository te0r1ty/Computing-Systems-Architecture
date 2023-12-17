.include "macrolib.s"
.global main

.data
	.align 2
	array:  .space  40              
	arrend:
	
.text
	main:
		li s8 -2147483648
		li s9 2147483647
		li s10 1
		li s11 10
		
		print_str("¬ведите размер массива от 1 до 10 включительно.\n")
		la s1 enter_size
		jalr s1
		mv t2 a0
		
		la t0 array
		li s11 1
		
		la s1 fill
		jalr s1
	
		la t0 array
		li s11 0
	sum:
		lw s7 (t0)
		addi t0 t0 4
		addi s11 s11 1
		andi t6 s7 1
		beqz t6 even
		j odd
		
	cont_sum:
		bgez s6 positive
		j negative
		
	even:
		addi t3 t3 1
		j cont_sum
	odd:
		addi t4 t4 1
		j cont_sum
		
	positive:
		sub s9 s9 s6
		blt s9 s7 bad_end
		add s6 s7 s6
		li s9 2147483647
		beq s11 t2 good_end
		j sum
	
	negative:
		sub s8 s8 s6
		blt s7 s8 bad_end
		add s6 s7 s6
		li s8 -2147483648
		beq s11 t2 good_end
		j sum
	
	
	bad_end:
		print_str("ѕереполнение :(\n")
		addi t2 t2 -1
	good_end:	
		jal ending_text
		exit