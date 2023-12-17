.include "str_lib.s"

# C strcpy() func implementation
.macro strcpy(%adr, %cpy_adr, %cpy_lim)
	    la a0 %adr
	    la t0 %cpy_adr
	    li a1 %cpy_lim
    	loop:
    	    lb t1 (a0)
    	    beqz t1 end
    	    beqz a1 source_is_long
    	    sb t1 (t0)
    	    addi a0 a0 1
    	    addi t0 t0 1
    	    addi a1 a1 -1
    	    j loop
    	source_is_long:
    	    print_str("The string is not copied completely.\nCopied string is too long for the copy storage.\n")
    	    newline
	end:
.end_macro 

# Sets all bytes to ZERO starting from adress untill the first ZERO byte	    	    
.macro clear(%adr)
	    la a0 %adr
	loop:
	    lb t1 (a0)
    	    beqz t1 end
    	    sb zero (a0)
    	    addi a0 a0 1
    	    j loop
	end:
.end_macro 

# Seminar sub-programm but in macro
.macro strnlen(%a0)
	    la a0 %a0
	    li t0 0       	# Счетчик
	    li t2 10
	loop:
	    lb t1 (a0)		# Загрузка символа для сравнения
	    beqz t1 end
	    beq t1 t2 end
	    addi t0 t0 1	# Счетчик символов увеличивается на 1
	    addi a0 a0 1	# Берется следующий символ
	    j loop
	end:
	    mv a0 t0
.end_macro 

# Prints the string
.macro print_str_adr(%adr)
	    la      a0 %adr
	    li      a7 4
	    ecall
.end_macro 

# Reads the input string
.macro read_str(%x, %y)
	    la a0 %x
	    li a1 %y
	    li a7 8
	    ecall
.end_macro 