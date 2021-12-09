.data
fin:	.asciiz "input.txt"
buffer:	.space 2048

wall:	.asciiz	"w"
passage:.asciiz "p"
player:	.asciiz "s"
exit:	.asciiz "u"
newline:.asciiz "\n"
enemy:	.asciiz "e"
candy:	.asciiz "c"

.globl main

.text
# Starting point
main:
	la 	$s0, fin	# load file name adress
	la 	$s1, buffer	# load buffer adress
	li	$s2, 2048	# load buffer size
	
	subu	$sp, $sp, 12	# adjust stack for 3 items
	sw	$s2, 12($sp)	# push buffer size to stack
	sw	$s1, 8($sp)	# push buffer adress
	sw	$s0, 4($sp)	# push file name
	
	jal	create
	
# Procedure to create a bitmap maze based on a .txt file
create:
	sw	$fp, 0($sp)	# push old frame pointer (dynamic link)
	move	$fp, $sp	# frame	pointer now points to the top of the stack
	subu	$sp, $sp, 28	# allocate 28 bytes on the stack
	sw	$ra, -4($fp)	# store the value of the return address
	sw	$v0, -8($fp)	# static link
	sw	$s0, -12($fp)	# save locally used registers
	sw	$s1, -16($fp)
	sw	$s2, -20($fp)
	sw	$s3, -24($fp)
	
	# Load arguments to registers
	lw	$s0, 4($fp)	# load file name to $s0
	lw	$s1, 8($fp)	# load buffer adress to $s1
	lw	$s2, 12($fp)	# load buffer size to $s2
	
	# Open file
	li 	$v0, 13		# System call for opening files
	move	$a0, $s0	# load file name in $a0
	li 	$a1, 0 		# Open for writing
	li	$a2, 0 		# mode is ignored
	syscall 		# open a file (file descriptor returned in $v0)
	move	$s3, $v0	# save file descriptor to $s3
	
	# Read from file to buffer
	li 	$v0, 14 	# system call for read from file
	move 	$a0, $s3 	# file descriptor
	move 	$a1, $s1	# address of buffer to which to load the contents
	move 	$a2, $s2 	# hardcoded max number of characters
	syscall 		# read file
	
	# Close file
	li 	$v0, 16		# system call for close file
	move	$a0, $s3	# file descriptor to close
	syscall			# close file
	
	# Determine width
	li	$s0, 0		# set $s0 as counter
	lw	$t1, 0($s1)	# set $t1 to the first character
width:
	beq	$s1, 10, width_end	# check if the character is a newline
	addi	$s0, $s0, 1	# add 1 to counter
	addi	$s1, $s1, 4	# move to next character
	j	width
width_end:
	li 	$v0, 1
	move 	$a0, $t1
	syscall
	
	lw	$ra, -8($fp)
	jr	$ra
	

	
