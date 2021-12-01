	.data
upt:	.asciiz "up\n"
downt:	.asciiz "down\n"
leftt:	.asciiz "left\n"
rightt:	.asciiz "right\n"
	
	.text
main:
	li $s0 0xffff0000		# 0xffff0000
	li $s1 0xffff0004		# 0xffff0004
	li $s2 0
	
	li $s3 122			# z
	li $s4 115			# s
	li $s5 113			# q
	li $s6 100			# d
	li $s7 120			# x
	
loop:
	lw $t0 0($s0)			# Laad 1 of 0 in t0
	beq $t0 $s2 sleep		# Bepaal of er een input is geweest
	lw $t1 0($s1)			# Store input in t1
	
	beq $s7 $t1 exit
	beq $s3 $t1 up
	beq $s4 $t1 down
	beq $s5 $t1 left
	beq $s6 $t1 right
	
	j sleep
	
sleep:
	li $v0 32			# Sleep
	li $a0 500
	syscall
	
	j loop
	
up:
	li $v0 4
	la $a0 upt
	syscall
	
	j sleep
	
down:
	li $v0 4
	la $a0 downt
	syscall
	
	j sleep
	
left:
	li $v0 4
	la $a0 leftt
	syscall
	
	j sleep
	
right:
	li $v0 4
	la $a0 rightt
	syscall
	
	j sleep
	
exit:
	li $v0 10
	syscall