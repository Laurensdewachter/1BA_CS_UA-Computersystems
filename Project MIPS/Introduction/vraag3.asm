	.data
newline:.asciiz	"\n"

	.text
main:
	# Ask for n
	li $v0 5
	syscall
	move $t1 $v0
	
	li $t0 1
	
loop:
	bgt $t0 $t1 exit
	li $t2 1
	
	inner_loop:
		bgt $t2 $t0 loop2
		
		li $v0 1
		move $a0 $t2
		syscall
		
		addi $t2 $t2 1
		j inner_loop
		
loop2:
	li $v0 4
	la $a0 newline
	syscall
	
	addi $t0 $t0 1
	
	j loop
	
exit:
	li $v0 10
	syscall
