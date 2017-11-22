# Name: Kabilan Sriranjan
# Student ID: 260671847

# Problem 2 - Dr. Ackermann or: How I Stopped Worrying and Learned to Love Recursion
###########################################################
.data
error: 		.asciiz "error: m, n must be non-negative integers\n"
prompt1:	.asciiz "Please enter a number\n"
prompt2:	.asciiz "Please enter another number\n"

.text 
###########################################################
main:
# get input from console using syscalls
	la $a0, prompt1 	#Load prompt for first number
	li $v0, 4
	syscall			#print prompt for first number
	li $v0, 5
	syscall			#read first number
	move $s0, $v0		#save first number to $s0
	
	la $a0, prompt2 	#Load prompt for second number
	li $v0, 4
	syscall			#print prompt for second number
	li $v0, 5
	syscall			#read second number
	move $s1, $v0		#save second number to $s1
	
# compute A on inputs
	move $a0, $s0		#put first number in $a0
	move $a1, $s1		#put second number in $a1
	jal A			#call ackermann
	
# print value to console and exit with status 0
	move $a0, $v0		#save ackermann value to $a0
	li $v0, 1		
	syscall			#print ackermann value
	
	li $v0, 17		
	li $a0, 0
	syscall			#exit program with status 0

###########################################################
# int A(int m, int n)
# computes Ackermann function
A: 
	addi $sp, $sp, -8	#make space on stack for return address and m
	sw $ra, 0($sp)		#save return address to stack
	sw $a0, 4($sp)		#save m to stack
	jal check		#call check preocdure to make sure the values are valid
	
	beq $a0, $zero, base	#base case is if m=0
	beq $a1, $zero, rec	#simple recursive call is if n=0
	
	move $s0, $a0		#remember m by saving it to $s0
	addi $a1, $a1, -1	#decrease n by one
	jal A			#call A(m,n-1)
	addi $a0, $s0, -1	#decrease m by one
	move $a1, $v0		#n is the result of the previous Ackermann call
	jal A			#call A(m-1, A(m, n-1))

base:	
	addi $v0, $a1, 1	#base case is just returning n+1
	j pop			#start popping stack

rec:
	addi $a0, $a0, -1	#decrease m by one
	addi $a1, $zero, 1	#set n to one
	jal A			#simple recursive case is A(m-1, 1)
pop:
	lw $ra, 0($sp)		#load return address on stack to $ra
	lw $s0, 4($sp)		#load m from stack to $s0 for previous recursive calls
	addi $sp, $sp, 8	#restore stack pointer
	jr $ra
	
###########################################################
# void check(int m, int n)
# checks that n, m are natural numbers
# prints error message and exits with status 1 on fail
check:
	blt $a0, $zero, failure	#if m is less than 0 go to failure
	blt $a1, $zero, failure	#if n is less than 0 go to failure
	jr $ra
failure:
	la $a0, error		#load error message to $a0
	li $v0, 4		
	syscall			#print error message
	li $v0, 17
	li $a0, 1		
	syscall			#exit program with  status 1
