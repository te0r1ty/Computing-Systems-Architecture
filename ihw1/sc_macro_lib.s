.include "fst_macro_lib.s"

.text

# Reads the size of the array from keyboard taking into account the conditions of the problem
.macro	size_enter
	enter_size:
		read_int_a0
		blt a0 s10 failed_size
		bgt a0 s11 failed_size
		j out
	failed_size:	
		print_str("Wrong size, enter the number again. An integer form 1 to 10 included.\n")
		j enter_size
	out:
		sw a0 Asize t6
.end_macro 
	
# Filles the %array with numbers read from keyboard.
.macro array_filler(%array)
		la t0 %array
		li s11 1
		lw t2 Asize
	fill:
		read_int_a0
		sw a0 (t0)
		addi t0 t0 4
		addi s11 s11 1
		ble s11 t2 fill
		li t2 0
.end_macro 

# Filles %sec_array with elements of %fst_arr based on filter the entered from keyboard
.macro array_analysis(%fst_arr, %sec_arr)
		read_int_a0
		mv s5 a0
		newline
		
		lw t2 Asize
		la s3 %fst_arr
		la s4 %sec_arr
	check:
		lw s6 (s3)
		rem s7 s6 s5
		bnez s7 b_input_skip
		sw s6 (s4)
		addi s4 s4 4
		addi t3 t3 1
	b_input_skip:
		addi s3 s3 4
		addi t2 t2 -1
		bnez t2 check
		sw t3 Bsize t4
.end_macro 

	

# Prints the %array on the screen
.macro print_array(%array, %size)
		beqz %size empty
	printer:
		lw s6 (%array)
		print_int(s6)
		print_str(" ")
		addi %array %array 4
		addi %size %size -1
		bnez %size printer
	empty:
		newline
.end_macro 
