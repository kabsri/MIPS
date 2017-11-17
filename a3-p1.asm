#StudentID: 260671847
#Name: Kabilan Sriranjan

.data
initialPrompt:	.asciiz "Enter characters to add to list. Use * to terminate list\n"
charPrompt:	.asciiz "\nEnter the next character\n"	 

.text
#There are no real limit as to what you can use
#to implement the 3 procedures EXCEPT that they
#must take the specified inputs and return at the
#specified outputs as seen on the assignment PDF.
#If convention is not followed, you will be
#deducted marks.

main:
	jal build
	
	li $v0, 10
	syscall
#build a linked list
#print "Original linked list\n"
#print the original linked list

#reverse the linked list
#On a new line, print "reversed linked list\n"
#print the reversed linked list
#terminate program

build:
#continually ask for user input UNTIL user inputs "*"
#FOR EACH user inputted character inG, create a new node that hold's inG AND an address for the next node
#at the end of build, return the address of the first node to $v1

	li $s0, '*'	#save '*' character to $s0 as it is important
	
	la $a0, initialPrompt 	#load prompt to $a0
	li $v0, 4
	syscall 	#print prompt on how to use method
	
	li $v0, 12
	syscall 	#read character
	move $t0, $v0	#save input character to $t0
	
	beq $s0, $v0, tail 	#if user entered a * then make tail
	
	li $a0, 8	#store 8 into $a0 to allocate 8 bytes to a node
	li $v0, 9
	syscall		#allocate 8 bytes to memory
	move $t2, $v0	#store head of list in $t2 so we can return it later
	
	move $t1, $v0 		#store address of malloc to $t1
	sw $t0, 4($t1)		#save character to second half of node
	
loop:
	la $a0, charPrompt	#load prompt to $a0
	li $v0, 4
	syscall			#print prompt for getting next character
	
	li $v0, 12
	syscall 	#read character
	move $t0, $v0	#save input character to $t0
	
	beq $s0, $v0, tail	#if user entered a * then make tail
	
	li $a0, 8	#store 8 into $a0 to allocate 8 bytes to a node
	li $v0, 9
	syscall		#allocate 8 bytes of memory
	
	la $v0, 0($t1)		#save location of current node in previous node
	move $t1, $v0		#store pointer to current node to $t1
	sw $t0, 4($t1)		#save character to second half of node
	j loop

tail:	
	move $v0, $t2
	jr $ra

print:
#$a0 takes the address of the first node
#prints the contents of each node in order

reverse:
#$a1 takes the address of the first node of a linked list
#reverses all the pointers in the linked list
#$v1 returns the address
