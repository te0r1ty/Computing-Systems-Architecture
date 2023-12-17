.include "macrolib.s"
.global fill
.global ending_text
.global enter_size

.text
	failed_size:	
		print_str("Введено неверное число, введите размер массива повторно. Число от 1 до 10 включительно.\n")
	enter_size:
		read_int_a0
		blt a0 s10 failed_size
		bgt a0 s11 failed_size
		ret
	
	fill:
		print_str("Введите число\n")
		read_int_a0
		sw a0 (t0)
		addi t0 t0 4
		addi s11 s11 1
		ble s11 t2 fill
		ret
			
	ending_text:
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
		
		ret
