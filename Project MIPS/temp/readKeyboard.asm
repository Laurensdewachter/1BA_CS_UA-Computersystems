	.data
message:.asciiz "Please enter a character\n"
newl:	.asciiz "\n"

	.text
main:
	li $s0 0xffff0000		# 0xffff0000
	li $s1 0xffff0004		# 0xffff0004
	li $s2 0
loop:
	lw $t0 0($s0)			# Laad 1 of 0 in t0
	beq $t0 $s2 empty		# Bepaal of er een input is geweest
	lw $t1 0($s1)			# Store input in t1
	
	li $v0 11			# Print input
	move $a0 $t1
	syscall
	
	li $v0 4
	la $a0 newl
	syscall
	
	li $v0 32			# Sleep
	li $a0 2000
	syscall
	
	j loop
empty:
	li $v0 4			# Vraag input
	la $a0 message
	syscall
	
	li $v0 32			# Sleep
	li $a0 2000
	syscall
	
	j loop
