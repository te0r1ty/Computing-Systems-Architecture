.global display_digit

.data
	msg:	.asciz	"Not a digit"	

.text
	display_digit:
.eqv		ZERO	0x3f
.eqv		ONE	0x6
.eqv		TWO	0x5b
.eqv		THREE	0x4f
.eqv		FOUR	0x66
.eqv		FIVE	0x6d
.eqv		SIX	0x7d
.eqv		SEVEN	0x7
.eqv		EIGHT	0x7f
.eqv		NINE	0x6f
		mv	t1 a0
		mv	t2 a1
		li	t3 16
		li 	t5 10
		li 	t6 0
		li 	t4 1
		bgt 	t1 t3 a_case
		blt	t1 t6 nan
		bge	t1 t5 nan
		j b_case
	a_case:
		rem	t1 t1 t3
		beqz 	t1 a_zero
		beq 	t1 t4 a_one
		addi 	t4 t4 1
		beq 	t1 t4 a_two
		addi 	t4 t4 1
		beq 	t1 t4 a_three
		addi 	t4 t4 1
		beq 	t1 t4 a_four
		addi 	t4 t4 1
		beq 	t1 t4 a_five
		addi 	t4 t4 1
		beq 	t1 t4 a_six
		addi 	t4 t4 1
		beq 	t1 t4 a_seven
		addi 	t4 t4 1
		beq 	t1 t4 a_eight
		addi 	t4 t4 1
		beq 	t1 t4 a_nine
	a_zero:
		addi	t1 t1 ZERO
		addi	t1 t1 128
		j display
	a_one:
		addi	t1 t1 -1
		addi	t1 t1 ONE
		addi	t1 t1 128
		j display
	a_two:
		addi	t1 t1 -2
		addi	t1 t1 TWO
		addi	t1 t1 128
		j display
	a_three:
		addi	t1 t1 -3
		addi	t1 t1 THREE
		addi	t1 t1 128
		j display
	a_four:
		addi	t1 t1 -4
		addi	t1 t1 FOUR
		addi	t1 t1 128
		j display
	a_five:
		addi	t1 t1 -5
		addi	t1 t1 FIVE
		addi	t1 t1 128
		j display
	a_six:
		addi	t1 t1 -6
		addi	t1 t1 SIX
		addi	t1 t1 128
		j display
	a_seven:
		addi	t1 t1 -7
		addi	t1 t1 SEVEN
		addi	t1 t1 128
		j display
	a_eight:
		addi	t1 t1 -8
		addi	t1 t1 EIGHT
		addi	t1 t1 128
		j display
	a_nine:
		addi	t1 t1 -9
		addi	t1 t1 NINE
		addi	t1 t1 128
		j display
	b_case:
		beqz 	t1 b_zero
		beq 	t1 t4 b_one
		addi 	t4 t4 1
		beq 	t1 t4 b_two
		addi 	t4 t4 1
		beq 	t1 t4 b_three
		addi 	t4 t4 1
		beq 	t1 t4 b_four
		addi 	t4 t4 1
		beq 	t1 t4 b_five
		addi 	t4 t4 1
		beq 	t1 t4 b_six
		addi 	t4 t4 1
		beq 	t1 t4 b_seven
		addi 	t4 t4 1
		beq 	t1 t4 b_eight
		addi 	t4 t4 1
		beq 	t1 t4 b_nine
	b_zero:
		addi	t1 t1 ZERO
		j display
	b_one:
		addi	t1 t1 -1
		addi	t1 t1 ONE
		j display
	b_two:
		addi	t1 t1 -2
		addi	t1 t1 TWO
		j display
	b_three:
		addi	t1 t1 -3
		addi	t1 t1 THREE
		j display
	b_four:
		addi	t1 t1 -4
		addi	t1 t1 FOUR
		j display
	b_five:
		addi	t1 t1 -5
		addi	t1 t1 FIVE
		j display
	b_six:
		addi	t1 t1 -6
		addi	t1 t1 SIX
		j display
	b_seven:
		addi	t1 t1 -7
		addi	t1 t1 SEVEN
		j display
	b_eight:
		addi	t1 t1 -8
		addi	t1 t1 EIGHT
		j display
	b_nine:
		addi	t1 t1 -9
		addi	t1 t1 NINE
		j display
	nan:
		li	a7 4
		la 	a0 msg
		ecall
		j return 
	display:
		sb	t1 (t2)
	return:
		ret