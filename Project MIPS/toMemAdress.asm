	.data
map:	.space 1024
	
	.text
main:
	li $s1 1
	li $s2 5
	
	la $s0 map
	
	# Calculate row
	sll $t0 $s2 7
	add $s0 $s0 $t0
	
	# Calculate colum
	sll $t0 $s1 2
	add $s0 $s0 $t0
	
	li $v0 1
	move $a0 $s0
	syscall

exit:
	li $v0 10
	syscall