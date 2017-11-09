# Program to capitalize the first letter of a string

	.data		# variable declarations follow this line
str: 	.asciiz "Enter the string to capitalize: "
strCap:	.space 127  	# allocate 127 bytes of memory for the string       
														
	.text		# instructions follow this line	
																	                    
main:     		# indicates start of code to test "upper" the procedure
	la $a0, str	# prompt the user for the string
	li $v0, 4
	syscall
	
	li $v0, 8	
	la $a0, strCap	# $a0 points to the spot in memory
	li $a1, 127	# $a1 is the number of bytes we are prepared to read
	syscall		# read inputed string into strCap
	
	la $a0, strCap	# make sure $a0 is the address of the string before we call upper
	jal upper
	
print:	li $v0, 4	# print the new, capitalized string
	la $a0, strCap
	syscall
	
exit:	li $v0, 10
	syscall		# exit the program


upper:	     		# the “upper” procedure
				# declare important, global, constants
	li $s0, 97		# integer value for 'a'
	li $s1, 122		# integer value for 'z'
	li $s2, ' '		# ' ', to check for spaces
	li $s3, '\n'		# '\n', to check for the end of the word
	
	lb $t0, 0($a0)		# check if first character needs to be capitalized
	blt $t0, $s0, loop	# go straight to loop if first character is less than 'a'
	bgt $t0, $s1, loop	# go straight to loop if first character is greater than 'z'
	subi $t0, $t0, 32	# if it's a lower case character then we need to subtract 32 from it to capitalize
	sb $t0, 0($a0)		# store capitalized letter to word
	
loop:	lb $t0 0($a0)			# save two pointers, one is to store the letter
	lb $t1 -1($a0)			# second pointer is to check if there is a space behind the letter
	beq $t1, $s2, capitalize	# if first pointer is a space then capitalize the second one
	beq $t1, $s3, print		# if first pointer is new line then we are done and can go to print 
	j inc				# if we aren't at a letter that needs to be capitazlied or the end of the word, just increment address and check next word

capitalize:
	lb $t0, 0($a0)		# the capitalize procedure takes an address and capitalizes the character in that address
	blt $t0, $s0, inc	# if the character is less than 97 it is not lower case so call inc
	bgt $t0, $s1, inc	# if the character is greater than 122 it is not lower case so call inc
	subi $t0, $t0, 32	# if the character is between 97 and 122 subtract 32 from it to make it upper case
	sb $t0 0($a0)		# store capitalized letter to word

inc:	
	la $a0 1($a0)		# add one to our address to check next letter
	j loop			# go back to loop
									
# End of program
