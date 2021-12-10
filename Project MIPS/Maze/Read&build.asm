.data
fin:	.asciiz "/home/laurens/Desktop/Systemen/Project MIPS/Maze/input.txt"
	.align 2
buffer:	.space 2048

.globl main

.text
# Starting point
main:
	la 	$s0, fin	# load file name adress
	la 	$s1, buffer	# load buffer adress
	li	$s2, 2048	# load buffer size
	
	subu	$sp, $sp, 12	# adjust stack for 3 items
	sw	$s2, 12($sp)	# push buffer size to stack
	sw	$s1, 8($sp)	# push buffer adress to stack
	sw	$s0, 4($sp)	# push file name adress to stack
	
	jal	create
	
	li	$v0, 10		# system call for returning to os
	syscall
	
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

# Procedure to read a file
read_file:
	# Load arguments to registers
	lw	$s1, 4($fp)	# load file name adress to $s0
	lw	$s0, 8($fp)	# load buffer adress to $s1
	lw	$s2, 12($fp)	# load buffer size to $s2
	
	# Open file
	li 	$v0, 13		# system call for opening files
	move	$a0, $s1	# load file name adress in $a0
	li 	$a1, 0 		# Open for writing
	li	$a2, 0 		# mode is ignored
	syscall 		# open a file (file descriptor returned in $v0)
	move	$s3, $v0	# save file descriptor to $s3
	
	# Read from file to buffer
	li 	$v0, 14 	# system call for read from file
	move 	$a0, $s3 	# file descriptor
	move 	$a1, $s0	# address of buffer to which to load the contents
	move 	$a2, $s2 	# hardcoded max number of characters
	syscall 		# read file
	
	# Close file
	li 	$v0, 16		# system call for close file
	move	$a0, $s3	# file descriptor to close
	syscall			# close file
	
# Procedure 
determine_width_height:
	# Determine width
	li	$t0, 0		# set $t0 as counter
	move 	$t1, $s0	# copy buffer location as "pointer"
width:
	lb	$t2, 0($t1)	# load character
	beq	$t2, 10, width_end	# check if the character is a newline
	addi	$t0, $t0, 1	# add 1 to counter
	addi	$t1, $t1, 1	# move to next character
	j	width		# loop
	
width_end:
	move	$s1, $t0	# save width to $s1
	li	$t0, 0		# set $t0 as counter
	move 	$t1, $s0	# copy buffer location as "pointer"
height:
	lb	$t2, ($t1)	# load next character
	beq	$t2, 0, height_end	# check if the character is not zero
	addi	$t1, $t1, 1	# move to next character
	beq	$t2, 10, counter	# jump to function that adds 1 to counter
	j	height		# loop
counter:
	addi	$t0, $t0, 1	# add 1 to counter
	j	height		#loop
	
height_end:
	addi	$t0, $t0, 1	# count the final row
	move	$s2, $t0	# store height to $s2

# Procedure to start filling the bitmap with the right colors
start_coloring:
	move	$t0, $s0	# load buffer adress to $t0 as "pointer"
	move	$s3, $gp	# load the bitmap pointer to "s3"
	li	$t2, 0x0000FF	# load blue to $t2
	li	$t3, 0x000000	# load black to $t3
	li	$t4, 0xFFFF00	# load yellow to $t4
	li	$t5, 0x00FF00	# load green to $t5
	li	$t6, 0xFF0000	# load red to $t6
	li	$t7, 0xFFFFFF	# load white to $t7
	
color:
	lb	$t1, ($t0)	# load byte to $t1
	addi	$t0, $t0, 1	# add 1 to "buffer pointer"
	
	beq	$t1, 119, wall	# check if the character is a "w"
	beq	$t1, 112, passage	# check if the character is a "p"
	beq	$t1, 115, player	# check if the character is a "s"
	beq	$t1, 117, exit	# check if the character is a "u"
	beq	$t1, 101, enemy	# check if the character is a "e"
	beq	$t1, 99, candy	# check if the character is a "c"
	beq	$t1, 13, color	# to make compatible with windows which has a carriage return (ascii-code 13) before the endline
	beq	$t1, 10, color	# to prevent the loop ending at endline
	j	color_end
	
wall:
	sw	$t2, 0($s3)	# place blue value at the bitmap "pointer"
	addi	$s3, $s3, 4	# move bitmap "pointer"
	j	color
passage:
	sw	$t3, 0($s3)	# place black value at the bitmap "pointer"
	addi	$s3, $s3, 4	# move bitmap "pointer"
	j	color
player:
	sw	$t4, 0($s3)	# place yellow value at the bitmap "pointer"
	addi	$s3, $s3, 4	# move bitmap "pointer"
	j	color
exit:
	sw	$t5, 0($s3)	# place green value at the bitmap "pointer"
	addi	$s3, $s3, 4	# move bitmap "pointer"
	j	color
enemy:
	sw	$t6, 0($s3)	# place red value at the bitmap "pointer"
	addi	$s3, $s3, 4	# move bitmap "pointer"
	j	color
candy:
	sw	$t7, 0($s3)	# place white value at the bitmap "pointer"
	addi	$s3, $s3, 4	# move bitmap "pointer"
	j	color
color_end:
	lw	$ra, -4($fp)
	jr	$ra
