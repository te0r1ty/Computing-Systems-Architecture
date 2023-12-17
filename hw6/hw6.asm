.include "strcpy.s"

.global main

.eqv     BUF_SIZE 100

.data
	buf:    	.space BUF_SIZE    	# ����� ��� ������ ������
	cpy:		.space BUF_SIZE
	empty_test_str: .asciz ""   		# ������ �������� ������
	short_test_str: .asciz "Hello!"   	# �������� �������� ������
	long_test_str:  .asciz "I am that long, that there is no this much space inside the buffer, so it overflows alomost right there bye" 	# ������� �������� ������

.text
	main:
	
	jal prikol
		read_str(buf, BUF_SIZE)
		strcpy(buf, cpy, BUF_SIZE)
		print_str_adr(cpy)
		clear(cpy)
		newline
		
		strcpy(empty_test_str, cpy, BUF_SIZE)
		print_str_adr(cpy)
		clear(cpy)
		newline
	
		newline
		strcpy(short_test_str, cpy, BUF_SIZE)
		print_str_adr(cpy)
		clear(cpy)
		newline
	
		newline
		strcpy(long_test_str, cpy, BUF_SIZE)
		print_str_adr(cpy)
		clear(cpy)
		
		
		
		
		
	  	exit
	  	
	  	
	  	
	  	
	  	
	prikol:
		li a0 3450
		li a7 1
		ecall
		ret
		

