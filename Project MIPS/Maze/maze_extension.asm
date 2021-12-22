# Using WASD keyboard setup
.data
fin:	.asciiz "/home/laurens/Desktop/Systemen/Project MIPS/Maze/input3.txt"
	.align 2
finw:	.asciiz "C:/Users/Laurens/Documents/UA/Informatica/SEM1/CSA/Systemen/Project MIPS/Maze/input2.txt"
	.align 2
buffer:	.space 2048
width:	.space 4
end:	.space 8
visited:.space 2048
victory_msg:	.asciiz "Victory!"

.globl main

.text
# Starting point
main:
	la 	$s0, fin	# load file name adress
	la 	$s1, buffer	# load buffer adress
	li	$s2, 2048	# load buffer size
	
	subu	$sp, $sp, 20	# adjust stack for 3 arguments and 2 return values
	sw	$s2, 20($sp)	# push buffer size to stack
	sw	$s1, 16($sp)	# push buffer adress to stack
	sw	$s0, 12($sp)	# push file name adress to stack
	
	jal	create
	
	jal	dfs
	
	li	$v0, 10		# system call for returning to os
	syscall
	
###################################################################################################
# Procedure to create a bitmap maze based on a .txt file
create:
	sw	$fp, ($sp)	# push old frame pointer (dynamic link)
	move	$fp, $sp	# frame	pointer now points to the top of the stack
	subu	$sp, $sp, 28	# allocate 28 bytes on the stack
	sw	$ra, -4($fp)	# store the value of the return address
	sw	$s0, -8($fp)	# save locally used registers
	sw	$s1, -12($fp)
	sw	$s2, -16($fp)
	sw	$s3, -20($fp)
	sw	$s4, -24($fp)

# Procedure to read a file
read_file:
	# Load arguments to registers
	lw	$s1, 12($fp)	# load file name adress to $s0
	lw	$s0, 16($fp)	# load buffer adress to $s1
	lw	$s2, 20($fp)	# load buffer size to $s2
	
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
	
# Procedure to determine the width and height of the maze
determine_width_height:
	# Determine width
	li	$t0, 0		# set $t0 as counter
	move 	$t1, $s0	# copy buffer location as "pointer"
width_create:
	lb	$t2, ($t1)	# load character
	beq	$t2, 13, width_end	# to make compatible with windows which has a carriage return (ascii-code 13) before the endline
	beq	$t2, 10, width_end	# check if the character is a newline
	addi	$t0, $t0, 1	# add 1 to counter
	addi	$t1, $t1, 1	# move to next character
	j	width_create		# loop
	
width_end:
	la	$t1, width	# load the adress for "width" in memory
	sw	$t0, ($t1)	# save width to "width" in memory
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
	j	starting_position
	
wall:
	sw	$t2, ($s3)	# place blue value at the bitmap "pointer"
	addi	$s3, $s3, 4	# move bitmap "pointer"
	j	color
passage:
	sw	$t3, ($s3)	# place black value at the bitmap "pointer"
	addi	$s3, $s3, 4	# move bitmap "pointer"
	j	color
player:
	sw	$t4, ($s3)	# place yellow value at the bitmap "pointer"
	addi	$s3, $s3, 4	# move bitmap "pointer"
	j	color
exit:
	sw	$t5, ($s3)	# place green value at the bitmap "pointer"
	addi	$s3, $s3, 4	# move bitmap "pointer"
	j	color
enemy:
	sw	$t6, ($s3)	# place red value at the bitmap "pointer"
	addi	$s3, $s3, 4	# move bitmap "pointer"
	j	color
candy:
	sw	$t7, ($s3)	# place white value at the bitmap "pointer"
	addi	$s3, $s3, 4	# move bitmap "pointer"
	j	color
# The maze is now build

# Procedure to determine the players location
starting_position:
	li	$t0, 0		# set up a counter in $t0
	move	$t1, $s0	# load buffer adress to $t1 as "pointer"
	
starting_position_loop:
	lb	$t2, ($t1)	# load character to $t2
	addi	$t1, $t1, 1	# add 1 to buffer "pointer"
	beq	$t2, 10, starting_position_loop	# check if the character is a newline
	beq	$t2, 13, starting_position_loop	# check if the character is a carriage return
	beq	$t2, 115, starting_position_end	# check if character is a "s"
	addi	$t0, $t0, 1	# add 1 to counter
	j starting_position_loop
	
starting_position_end:
	div	$t0, $s1	# divide counter by width
	mfhi	$s3		# store column in $s3
	mflo	$s4		# store row in $s4

# Procedure to determine the end location
ending_position:
	li	$t0, 0		# set up a counter in $t0
	move	$t1, $s0	# load buffer adress to $t1 as "pointer"
	
ending_position_loop:
	lb	$t2, ($t1)	# load character to $t2
	addi	$t1, $t1, 1	# add 1 to buffer "pointer"
	beq	$t2, 10, ending_position_loop	# check if the character is a newline
	beq	$t2, 13, ending_position_loop	# check if the character is a carriage return
	beq	$t2, 117, ending_position_end	# check if character is a "u"
	addi	$t0, $t0, 1	# add 1 to counter
	j ending_position_loop
	
ending_position_end:
	div	$t0, $s1	# divide counter by width
	mfhi	$t0		# store column in $s3
	mflo	$t1		# store row in $s4
	
	la	$t2, end	# load adress to store end
	sw	$t1, ($t2)	# store row
	sw	$t0, 4($t2)	# store column

# Restore all registers to end the function
return:
	sw	$s3, 8($fp)	# Store player position column on stack as return value
	sw	$s4, 4($fp)	# Store player position row on stack as return value
	
	lw	$s4, -24($fp)	# restore locally used registers
	lw	$s3, -20($fp)
	lw	$s2, -16($fp)
	lw	$s1, -12($fp)
	lw	$s0, -8($fp)
	lw	$ra, -4($fp)	# restore return adress
	move	$sp, $fp	# get old frame pointer from current frame
	lw	$fp, ($sp)	# restore old frame pointer
	jr	$ra
###################################################################################################

###################################################################################################
# Procedure to calculate the corresponding memory adress of a coordinate
toMemAdress:
	sw	$fp, ($sp)	# push old frame pointer (dynamic link)
	move	$fp, $sp	# frame	pointer now points to the top of the stack 
	subu	$sp, $sp, 12	# allocate 8 bytes on the stack
	sw	$ra, -4($fp)	# store the value of the return address
	
	la	$t0, width	# load the adress for "width" in memory
	lw	$t1, ($t0)	# load width from "width" in memory
	sll	$t1, $t1, 2	
	
	mul	$t0, $a0, $t1	# multiply the amount of rows with the width
	sll	$t2, $a1, 2	# multiply the column by 4
	add	$t0, $t0, $t2	# add the column
	
	add	$v0, $gp, $t0
	
	lw	$ra, -4($fp)	# restore return adress
	move	$sp, $fp	# get old frame pointer from current frame
	lw	$fp, ($sp)	# restore old frame pointer
	jr	$ra
###################################################################################################

###################################################################################################
# Procedure to update the players position
player_position:
	sw	$fp, ($sp)	# push old frame pointer (dynamic link)
	move	$fp, $sp	# frame	pointer now points to the top of the stack
	subu	$sp, $sp, 24	# allocate 24 bytes on the stack
	sw	$ra, -4($fp)	# store the value of the return address
	sw	$s0, -8($fp)	# save locally used registers
	sw	$s1, -12($fp)
	sw	$s2, -16($fp)
	sw	$s3, -20($fp)
	
	lw	$s0, 4($fp)	# load player row to $s0
	lw	$s1, 8($fp)	# load player column to $s1
	lw	$s2, 12($fp)	# load new row to $s2
	lw	$s3, 16($fp)	# load new column to $s3
	
check_possibility:
	move	$a0, $s2	# load new player row for toMemAdress
	move	$a1, $s3	# load new player column for toMemAdress
	
	jal	toMemAdress	# call toMemAdress procedure
	
	li	$t0, 0x0000FF	# load the colour blue to $t0
	lw	$t1, ($v0)	# load the colour at the new player location
	beq	$t0, $t1, invalid_move	# if the new location is blue (wall) the move is invalid
	
move_player:
	li	$t0, 0xFFFF00	# load yellow to $t0
	sw	$t0, ($v0)	# store yellow at the new player loaction memory adress
	
	move	$a0, $s0	# load old player row for toMemAdress
	move	$a1, $s1	# load old player column for toMemAdress
	
	jal	toMemAdress	# call toMemAdress procedure
	
	li	$t0, 0x000000	# load black to $t0
	sw	$t0, ($v0)	# make to old player position black
	
	move	$v0, $s2	# store the new player row in $v0
	move	$v1, $s3	# store the new player column in $v1
	
	j	player_position_return
	
invalid_move:
	move	$v0, $s0	# load the current player row to $v0
	move	$v1, $s1	# load the current player column to $v0

player_position_return:
	lw	$s3, -20($fp)	# restore locally used registers
	lw	$s2, -16($fp)
	lw	$s1, -12($fp)
	lw	$s0, -8($fp)
	lw	$ra, -4($fp)	# restore return adress
	move	$sp, $fp	# get old frame pointer from current frame
	lw	$fp, ($sp)	# restore old frame pointer
	jr	$ra
###################################################################################################

###################################################################################################
# Procedure to automaticaly find the exit
dfs:
	sw	$fp, ($sp)	# push old frame pointer (dynamic link)
	move	$fp, $sp	# frame	pointer now points to the top of the stack
	subu	$sp, $sp, 36	# allocate 32 bytes on the stack
	sw	$ra, -4($fp)	# store the value of the return address
	sw	$s0, -8($fp)	# save locally used registers
	sw	$s1, -12($fp)
	sw	$s2, -16($fp)
	sw	$s3, -20($fp)
	sw	$s4, -24($fp)
	sw	$s5, -28($fp)
	sw	$s6, -32($fp)

	lw	$s0, 4($fp)	# load the current row to $s0
	lw	$s1, 8($fp)	# load the current column to $s1
	
	la	$t0, end	# load adress of end location
	lw	$s2, ($t0)	# load end row
	lw	$s3, 4($t0)	# load end column

check_victory:
	seq	$t0, $s0, $s2	# compare player row to end row
	seq	$t1, $s1, $s3	# compare player column to end column
	add	$t0, $t0, $t1
	beq	$t0, 2, victory
	j	for_setup

victory:
	li	$v0, 4		# load print string syscall value
	la	$a0, victory_msg
	syscall
	j	dfs_end

for_setup:
	li	$t0, 0		# set up a counter in $t0
for:
	beq	$t0, 0, for1	# check if this is the first time the procedure runs the for loop
	beq	$t0, 1, for2	# check if this is the second time
	beq	$t0, 2, for3	# check if this is the thirth time
	j	for4		# it has to be the fourth time
	
for1:
	move	$s4, $s0	# store the current player row to $s4
	subu	$s4, $s4, 1	# create a new location
	move	$s5, $s1	# store the current player column to $s5
	
	j	check_visited

for2:
	move	$s4, $s0	# store the current player row to $s4
	addi	$s4, $s4, 1	# create a new location
	move	$s5, $s1	# store the current player column to $s5
	
	j	check_visited

for3:
	move	$s4, $s0	# store the current player row to $s4
	move	$s5, $s1	# store the current player column to $s5
	subu	$s5, $s5, 1	# create a new location
	
	j	check_visited

for4:
	move	$s4, $s0	# store the current player row to $s4
	move	$s5, $s1	# store the current player column to $s5
	addi	$s5, $s5, 1	# create a new location
	
	j	check_visited
	
check_visited:
	addi	$t0, $t0, 1	# update the counter
	
	la	$t1, visited	# load the adress of the space containing the visited locations
	lw	$t2, ($t1)	# load the first visited row
	lw	$t3, 4($t1)	# load the first visited column

check_visited_loop:
	seq	$t4, $t2, 0	# check if both spaces are 0
	seq	$t5, $t3, 0
	add	$t4, $t4, $t5
	beq	$t4, 2, check_visited_ok	# the new location hasn't been visited before
	
	seq	$t4, $t2, $s4	# check if the new location is equal to the one currently loaded from the visited locations
	seq	$t5, $t3, $s5
	add	$t4, $t4, $t5
	beq	$t4, 2, for
	
	addi	$t1, $t1, 8	# move the visited locations "pointer" to the next location
	lw	$t2, ($t1)	# load the next visited row
	lw	$t3, 4($t1)	# load the next visited column
	
	j	check_visited_loop
	
check_visited_ok:
	move	$s6, $t1	# keep the last empty space in visited in $s6

	subu	$sp, $sp, 16	# allocate 16 byte on the stack
	sw	$s0, 4($sp)	# push the current player row on the stack
	sw	$s1, 8($sp)	# push the current player column on the stack
	sw	$s4, 12($sp)	# push the updated player row on the stack
	sw	$s5, 16($sp)	# push the updated player column on the stack
	
	jal	player_position	# update the players position
	
	move	$t1, $v0	# keep the updated player row in $t1
	move	$t2, $v1	# keep the updated player column in $t1
	
	li	$v0, 32		# sleep
	li	$a0, 1000
	syscall
	
	seq	$t3, $s0, $t1	# check if the new location is equal to the current location
	seq	$t4, $s1, $t2
	add	$t3, $t3, $t4
	beq	$t3, 2, last_update
	
	subu	$sp, $sp, 8	# allocate 8 byte on the stack
	sw	$v0, 4($sp)	# push the updated player row to the stack
	sw	$v1, 8($sp)	# push the updated player column to the stack
	
	sw	$s4, ($s6)	# store the new player row and column in the visited array
	sw	$s5, 4($s6)
	
	jal	dfs
	
last_update:
	subu	$sp, $sp, 16	# allocate 16 bytes on the stack
	sw	$t1, 4($sp)	# push the updated player row to the stack
	sw	$t2, 8($sp)	# push the updated player column to the stack
	sw	$s0, 12($sp)	# push the old (or current) player row to the stack
	sw	$s1, 16($sp)	# push the old (or current) player column to the stack
	
	jal	player_position
	
	li	$v0, 32		# sleep
	li	$a0, 1000
	syscall

dfs_end:
	lw	$s3, -20($fp)	# restore locally used registers
	lw	$s2, -16($fp)
	lw	$s1, -12($fp)
	lw	$s0, -8($fp)
	lw	$ra, -4($fp)	# restore return adress
	move	$sp, $fp	# get old frame pointer from current frame
	lw	$fp, ($sp)	# restore old frame pointer
	jr	$ra
###################################################################################################
