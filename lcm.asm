# Program to calculate the least common multiple of two numbers

	.data		# variable declarations follow this line
first: 	.word 200	# the first integer
second: .word 32    	# the second integer                  
														
	.text		# instructions follow this line	
																	                    
main:     		# indicates start of code to test lcm the procedure
	lw $a0, first   # save the first and second numbers into argument registors
	lw $a1, second
	
	jal lcm 	# call lcm with the two arguments
	
	li $v0, 1
	syscall		# print the final value of $a0 (we can also print the final value of $a1 instead) 
	li $v0, 10
	syscall		# exit the program


lcm:	     		# the “lcm” procedure
	slt $t0, $a0, $a1	# if first argument is less than second, increase it to the next multiple of "first"
	bne $t0, $0, incFirst
	slt $t0, $a1, $a0	# if second argument is less than first, increase it to the next multiple of "second"
	bne $t0, $0, incSecond
	addi $v0, $a0, 0	# if both arguments are equal than we have found the lcm and so we save it to the return value register
	jr $ra			#return back to main

incFirst:
	lw $s0 first
	add $a0, $a0, $s0	# increase the first argument by "first"
	j lcm			# go back to lcm method with new first argument

incSecond:
	lw $s0 second
	add $a1, $a1, $s0	# increase the second argument by "second"
	j lcm			# go back to lcm method with new second argument

								
# End of program
