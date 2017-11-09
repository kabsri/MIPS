# Program to implement the Dijkstra's GCD algorithm

	.data		# variable declarations follow this line
str1: 	.asciiz "Enter the first integer: "
str2: 	.asciiz "Enter the second integer: "                  
														
	.text		# instructions follow this line	
	
main:     		# indicates start of code to test gcd the procedure
	la $a0, str1		# print prompt for first number
	li $v0, 4
	syscall
	li $v0, 5		# set $v0 to 5 to read the first integer
	syscall	
	addi $a1, $v0, 0	# take the input and save it as the second argument, as we still need to use the first one
	
	la $a0, str2		# print prompt for second number
	li $v0, 4
	syscall
	li $v0, 5		# set $v0 to 5 to read the next integer
	syscall
	addi $a0, $v0, 0	# take the input and save it to the first argument
	
	jal gcd		# run gcd procedure with our numbers in $a0 and $a1
	
	li $v0, 1	# set $v0 to 1 to print the gcd
	syscall
	li $v0, 10	# set $v0 to 10 to exit the program
	syscall													                    
																	                    																	                    
																	                    																	                    																	                    																	                    
gcd:	     		# the “gcd” procedure
	slt $t0, $a0, $a1	# if $a0 is less than $a1 then we need to decrease $a1
	bne $t0, $0, decSecond	
	slt $t0, $a1, $a0	# if $a1 is less than $a0 then we need to decrease $a0
	bne $t0, $0, decFirst
	jr $ra			# if neither of the previous branches happened then both are equal and so we have found the gcd and can return

decFirst:
	sub $a0, $a0, $a1	# decrease $a0 by the amount in $a1 for Dijkstra's algorithn
	j stack			# go to stack procedure for recursive call

decSecond:
	sub $a1, $a1, $a0	# decrease $a1 by the amount in $a0 for Dijkstra's algorithm
	j stack			# go to stack procedure for recursive call

stack:
	subi $sp, $sp, 4	# make space on stack to prepare for recursive call
	sw $ra, 0($sp)		# save current spot on top of stack
	
	jal gcd			# recursively call gcd with new $a0 and $a1
	
	lw $ra, 0($sp)		# after the base case, we can start popping stack
	addi $sp $sp, 4		
	
	jr $ra			# if stack isn't fully popped yet, go back to line 51, if we are popped then we go back to line 24						
# End of program
