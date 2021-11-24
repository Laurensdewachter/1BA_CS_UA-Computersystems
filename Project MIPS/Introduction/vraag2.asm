	.data
var_a:	.word	10
var_b:	.word	1
newline:.asciiz	"\n"

	.text
main:
	lw $t1 var_a
	lw $t2 var_b
	li $t0 0
	
loop:
	bge $t0 $t1 exit
	
	# Print nunmber
	li $v0 1
	move $a0 $t2
	syscall
	
	# Print newline
	li $v0 4
	la $a0 newline
    syscall
	
	# add to counter and to number
	addi $t2 $t2 1
	addi $t0 $t0 1
	j loop

exit:
	li $v0 10
	syscall
