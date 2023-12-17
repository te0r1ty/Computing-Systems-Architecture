.global main

.macro clear_DLS
		li 	s0 0xffff0010
		li	s1 0xffff0011
		sb 	zero (s0)
		sb	zero (s1)
.end_macro 

.macro sleep(%x)
		li 	a0 %x
		li	a7 32
		ecall
.end_macro 

.text
	main:
		li	s10 10
		li 	s11 0
		
	loop1:
		mv	a0 s11
		li 	a1 0xffff0010
		jal 	display_digit
		sleep(1000)
		clear_DLS
		sleep(1000)
		mv	a0 s11
		li 	a1 0xffff0011
		jal 	display_digit
		sleep(1000)
		clear_DLS
		sleep(1000)
		addi 	s11 s11 1
		bne	s10 s11 loop1
		
		li	s10 26
		li 	s11 16
		
	loop2:
		mv	a0 s11
		li 	a1 0xffff0010
		jal 	display_digit
		sleep(1000)
		clear_DLS
		sleep(1000)
		mv	a0 s11
		li 	a1 0xffff0011
		jal 	display_digit
		sleep(1000)
		clear_DLS
		sleep(1000)
		addi 	s11 s11 1
		bne	s10 s11 loop2
		
		li 	a7 10
		ecall