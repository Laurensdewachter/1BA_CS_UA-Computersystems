	.data
prime:	.asciiz "--Prime--"
notprime:	.asciiz "--No prime--"

	.text
main:
	# Get the number to be checked
	li $v0 5
	syscall
	move $s0 $v0
	
	li $t0 1
	li $t1 2
	ble $s0 $t0 isNotPrime	# If smaller or equal than/to 1
	beq $s0 $t1 isPrime	# If 2
	
	div $s0 $t1
	mfhi $t2
	addi $t1 $t1 1

	
while:
	beq $t1 $s0 isPrime	# if equal -> prime
	beq $t2 $zero isNotPrime	# If mod = 0 -> notPrime
	
	div $s0 $t1
	mfhi $t2
	addi $t1 $t1 1
	
	j while
	
isPrime:
	li $v0 4
	la $a0 prime
	syscall
	j exit
	
isNotPrime:
	li $v0 4
	la $a0 notprime
	syscall
	j exit
exit:
	li $v0 10
	syscall