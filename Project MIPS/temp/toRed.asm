	.data
	
	.text
	# Address first byte of bitmap
	move $s0 $gp
	
	li $s1 16711680
	
	li $t0 0
	li $t1 1024
	
loop:
	beq $t0 $t1 exit
	# Add 1 to loop
	addi $t1 $t1 1
	# Make red
	sw $s1 0($s0)
	# Move adress
	addi $s0 $s0 4
	
	j loop

exit:
	li $v0 10
	syscall