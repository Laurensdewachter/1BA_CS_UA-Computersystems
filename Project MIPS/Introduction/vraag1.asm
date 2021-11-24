	.data
message1:	.asciiz		"This is my "
message2:	.asciiz		"-th MIPS-program"

	.text
main:
	
	# Read n
	li $v0 5
	syscall
	move $t0 $v0
	
	# Print "This is my n-th MIPS-program"
	la $a0 message1
	li $v0 4
	syscall
	
	move $a0 $t0
	li $v0 1
	syscall
	
	la $a0 message2
	li $v0 4
	syscall
	
exit:
	li $v0 10
	syscall	
