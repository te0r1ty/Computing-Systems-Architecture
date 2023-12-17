.include "macrolib.s"

.text

.macro	size_enter
	enter_size:
		read_int_a0
		blt a0 s10 failed_size
		bgt a0 s11 failed_size
		j out
	failed_size:	
		print_str("Введено неверное число, введите размер массива повторно. Число от 1 до 10 включительно.\n")
		j enter_size
	out:
.end_macro 
	
.macro array_filler
	fill:
		print_str("Введите число\n")
		read_int_a0
		sw a0 (t0)
		addi t0 t0 4
		addi s11 s11 1
		ble s11 t2 fill
.end_macro 
		
.macro array_analysis
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
.end_macro 
					
.macro ending_text
		print_str("Сумма: ")
		print_int(s6)
		newline
		
		print_str("Количество: ")
		print_int(t2)
		newline
		
		print_str("Четные: ")
		print_int(t3)
		newline
		
		print_str("Нечетные: ")
		print_int(t4)
		newline
.end_macro 		