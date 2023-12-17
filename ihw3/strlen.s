# Моделирование функции strlen(asciiz_string)
    .text
.globl strlen
strlen:
    li      t0 0        	# Счетчик
loop:
    lb      t1 (a0)   		# Загрузка символа для сравнения
    beqz    t1 end
    addi    t0 t0 1		# Счетчик символов увеличивается на 1
    addi    a0 a0 1		# Берется следующий символ
    b       loop
end:
    mv      a0 t0
    ret
fatal:
    li      a0 -1
    ret