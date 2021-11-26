	.data
	
	.text
	# Address first byte of bitmap
	move $s0 $gp
	
	# Red
	li $s1 16711680
	# Yellow
	li $s2 16776960
	
	li $t0 0
	li $t1 1024
	
loop:
	beq $t0 $t1 bar
	# Add 1 to loop
	addi $t0 $t0 1
	# Make red
	sw $s1 0($s0)
	# Move adress
	addi $s0 $s0 4
	
	j loop

bar:
	move $s0 $gp
	
	li $t0 0
	li $t1 32
	
loopYellow1:
	beq $t0 $t1 bar2
	# Add 1 to loop
	addi $t0 $t0 1
	# Make yellow
	sw $s2 0($s0)
	# Move adress
	addi $s0 $s0 4
	
	j loopYellow1
	
bar2:
	li $t0 0
	li $t1 30
	mul $t2 $t1 4
	
loopYellow2:
	beq $t0 $t1 exit
	# Add 1 to loop
	addi $t0 $t0 1
	# Make yellow
	sw $s2 0($s0)
	# Move to other end
	add $s0 $s0 $t2
	# Make yellow
	sw $s2 0($s0)
	# Move to next row
	addi $s0 $s0 4

exit:
	li $v0 10
	syscall
