	.data
pi:	.float 3.14

	.text
main:	
	# Ask radius
	li $v0 6
	syscall
	
	# Calculate
	la $t1 pi
	l.s $f1 ($t1)
	
	mul.s $f3 $f0 $f0
	mul.s $f12 $f1 $f3
	
	li $v0 2
	syscall
	j exit
	
exit:
	li $v0 10
	syscall