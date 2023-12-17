.include "macro-syscalls.s"

# Макрос берущий в качетсве аргументов регистр с адресом начала текста,
# регистр с адресом конца текста и регистр с количеством символов в тексте
# и меняет значения двух последних регистров в случае необходимости.
.macro replace_digits(%start_adr, %end_adr, %txt_size)
		mv 	s8 %start_adr
	loop:
		lb 	s10 (s8)
		beq 	s10 zero end 		# проверка на машинный ноль
		
		li	s9 57			
		bgt	s10 s9 next		# проверка на то, 
		addi 	s9 s9 -8		# является ли ASCII-символ цифрой
		blt 	s10 s9 next
		
		beq	s10 s9 case_one		# Узнаём цифру
		addi	s9 s9 1
		beq	s10 s9 case_two
		addi	s9 s9 1
		beq	s10 s9 case_three
		addi	s9 s9 1
		beq	s10 s9 case_four
		addi	s9 s9 1
		beq	s10 s9 case_five
		addi	s9 s9 1
		beq	s10 s9 case_six
		addi	s9 s9 1
		beq	s10 s9 case_seven
		addi	s9 s9 1
		beq	s10 s9 case_eight
		addi	s9 s9 1
		beq	s10 s9 case_nine
		j next
		
	# Все метки включающие слово case - это метки обработки случая для каждой цифры
	# работают аналогично друг другу, распишу на примере case_three
	##########################	
	case_one:
		addi 	s10 s10 24
		sb	s10 (s8)
		j next
	##########################	
	case_two:
		addi	s10 s10 23			
		sb	s10 (s8)
		allocate(1)				
		addi 	%txt_size %txt_size 1
		add	s11 %start_adr %txt_size
		addi 	%end_adr %end_adr 1 
	inner_loop2:
		beq	s11 s8 cont2
		lb	t6 (s11)
		sb	t6 1(s11)
		addi 	s11 s11 -1
		j inner_loop2
	cont2:
		addi 	s8 s8 1
		sb	s10 (s8)
		j next
	##########################		
	case_three:	
		addi	s10 s10 22			# Сразу меняем первый символ, в которм находится цифра
		sb	s10 (s8)			
		allocate(2)				# Выделяем память на новые символы
		addi 	%txt_size %txt_size 2
		add	s11 %start_adr %txt_size	# Увеличиваем необходимые параметры, в соответсвии обрабатываемой цифре
		addi 	%end_adr %end_adr 2 
	inner_loop3:
		beq	s11 s8 cont3
		lb	t6 (s11)			# Цикл двигающий весь последющий текст
		sb	t6 2(s11)			# для освобождения места под новые символы
		addi 	s11 s11 -1			
		j inner_loop3
	cont3:
		addi 	s8 s8 1
		sb	s10 (s8)			# Вставляем необходимые символы в освободившиеся ячейки
		addi 	s8 s8 1
		sb	s10 (s8)
		j next					# След. итерация
	##########################
	case_four:	
		addi	s10 s10 21
		sb	s10 (s8)
		allocate(1)
		addi 	%txt_size %txt_size 1
		add	s11 %start_adr %txt_size
		addi 	%end_adr %end_adr 1 
	inner_loop4:
		beq	s11 s8 cont4
		lb	t6 (s11)
		sb	t6 1(s11)
		addi 	s11 s11 -1
		j inner_loop4
	cont4:
		addi 	s8 s8 1
		addi 	s10 s10 13
		sb	s10 (s8)
		j next
	##########################
	case_five:
		addi	s10 s10 33
		sb	s10 (s8)
		j next
	##########################
	case_six:	
		addi	s10 s10 32
		sb	s10 (s8)
		allocate(1)
		addi 	%txt_size %txt_size 1
		add	s11 %start_adr %txt_size
		addi 	%end_adr %end_adr 1 
	inner_loop6:
		beq	s11 s8 cont6
		lb	t6 (s11)
		sb	t6 1(s11)
		addi 	s11 s11 -1
		j inner_loop6
	cont6:
		addi 	s8 s8 1
		addi 	s10 s10 -13
		sb	s10 (s8)
		j next
	##########################
	case_seven:	
		addi	s10 s10 31
		sb	s10 (s8)
		allocate(2)
		addi 	%txt_size %txt_size 2
		add	s11 %start_adr %txt_size
		addi 	%end_adr %end_adr 2
	inner_loop7:
		beq	s11 s8 cont7
		lb	t6 (s11)
		sb	t6 2(s11)
		addi 	s11 s11 -1
		j inner_loop7
	cont7:
		addi 	s8 s8 1
		addi 	s10 s10 -13
		sb	s10 (s8)
		addi 	s8 s8 1
		sb	s10 (s8)
		j next
	##########################
	case_eight:	
		addi	s10 s10 30
		sb	s10 (s8)
		allocate(3)
		addi 	%txt_size %txt_size 3
		add	s11 %start_adr %txt_size
		addi 	%end_adr %end_adr 3
	inner_loop8:
		beq	s11 s8 cont8
		lb	t6 (s11)
		sb	t6 3(s11)
		addi 	s11 s11 -1
		j inner_loop8
	cont8:
		addi 	s8 s8 1
		addi 	s10 s10 -13
		sb	s10 (s8)
		addi 	s8 s8 1
		sb	s10 (s8)
		addi 	s8 s8 1
		sb	s10 (s8)
		j next
	##########################
	case_nine:
		addi	s10 s10 16
		sb	s10 (s8)
		allocate(1)
		addi 	%txt_size %txt_size 1
		add	s11 %start_adr %txt_size
		addi 	%end_adr %end_adr 1 
	inner_loop9:
		beq	s11 s8 cont9
		lb	t6 (s11)
		sb	t6 1(s11)
		addi 	s11 s11 -1
		j inner_loop9
	cont9:
		addi 	s8 s8 1
		addi	s10 s10 15
		sb	s10 (s8)
		j next
	##########################
	next:
		addi s8 s8 1		
		b loop
	end:
.end_macro 

.macro yorn
	li a7 12
	ecall
.end_macro 