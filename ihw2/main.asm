.include "seminar_macro_lib.s"
.global main

.data
		.align 	3
	result: .double	0
	eps:	.double 0.999

.text
	main:
		# Reading and checking entered x
		read_double(ft1)
		feq.d t2 ft1 ft2
		bnez t2 error_exit
		
		jal count_cth
		
		fmv.d fa0 fs4
		li a7 3
		ecall
		
		exit
		
		
	# Literally counts cth(x)	
	count_cth: 
		li t1 3
		fld fs6 eps s6
		
		exp(ft1, t1)
		li s5 1
		fcvt.d.w fs2 s5
		fdiv.d fs2 fs2 fs1
		fadd.d fs7 fs1 fs2
		fsub.d fs8 fs1 fs2
		fdiv.d fs3 fs7 fs8
	loop:
		fmv.d fs3 fs4
		addi t1 t1 1
		
		exp(ft1, t1)
		li s5 1
		fcvt.d.w fs2 s5
		fdiv.d fs2 fs2 fs1
		fadd.d fs7 fs1 fs2
		fsub.d fs8 fs1 fs2
		fdiv.d fs4 fs7 fs8
		
		fdiv.d fs5 fs3 fs4
		fge.d t2 fs5 fs6
		beqz t2 loop
		ret
		
		
	# Exit for case of x == 0	
	error_exit:
		print_str("Invalid x.\nEnding the program.")
		exit