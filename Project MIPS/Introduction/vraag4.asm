	.eqv LAST_CASE_NUM 2
	.eqv LAST_CASE_NUM_PLUS1_TIMES4 12
	
	.data
	
	.align 2
	
jumpTbl:.space LAST_CASE_NUM_PLUS1_TIMES4
expr_value:	.word 1
result:	.word 0

	.text
	la $s0 jumpTbl
	la $t0 case0
	sw $t0 0($s0)
	la $t0 case1
	sw $t0 4($s0)
	la $t0 case2
	sw $t0 8($s0)
	
	la $t0 result
	lw $s1 0($t0)
	
	la $t0 expr_value
	lw $s2 0($t0)
	
	blt $s2 $zero default
	li $t0 LAST_CASE_NUM
	bgt $s2 $t0 default
	
	sll $t1 $s2 2
	add $t1 $s0 $t1
	lw $t2 0($t1)
	jr $t2
	
case0:
	li $s1 9
	j endSwitch
case1:
	li $s1 6

case2:
	li $s1 8
	j endSwitch
default:
	li $s1 7
	j endSwitch
endSwitch:
	li $v0 1
	move $a0 $s1
	syscall
	j exit
exit:
	li $v0 10
	syscall