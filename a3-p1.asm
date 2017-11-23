#StudentID: 260671847
#Name: Kabilan Sriranjan

.data
initialPrompt:	.asciiz "Enter characters to add to list. Use * to terminate list\n"
charPrompt:	.asciiz "\nEnter the next character\n"
newLine:	.asciiz "\n" 
original:	.asciiz "\nOriginal linked list\n"
reversed:	.asciiz "\nReversed linked list\n"

.text
#There are no real limit as to what you can use
#to implement the 3 procedures EXCEPT that they
#must take the specified inputs and return at the
#specified outputs as seen on the assignment PDF.
#If convention is not followed, you will be
#deducted marks.

main:
#build a linked list
#print "Original linked list\n"
#print the original linked list
	jal build		#build linked list from user input
	move $s0, $v1		#save linked list head to $s0
	la $a0, original
	li $v0, 4
	syscall			#print "original linked list"
	move $a0, $s0		#put head of list in $a0
	jal print		#print original list

#reverse the linked list
#On a new line, print "reversed linked list\n"
#print the reversed linked list
#terminate program	
	move $a1, $s0		#put linked list in $a1 to reverse
	jal reverse		#reverse the linked list
	move $s1, $v1		#save reversed list to $s0
	la $a0, reversed
	li $v0, 4
	syscall			#print "reversed linked list"
	move $a0, $s1		#put head of list in $a0
	jal print		#print reversed list
	
	li $v0, 10
	syscall			#terminate program



build:
#continually ask for user input UNTIL user inputs "*"
#FOR EACH user inputted character inG, create a new node that hold's inG AND an address for the next node
#at the end of build, return the address of the first node to $v1

	li $s0, '*'		#save '*' character to $s0 as it is important
	
	la $a0, initialPrompt 	#load prompt to $a0
	li $v0, 4
	syscall 		#print prompt on how to use method
	
	li $v0, 12
	syscall 		#read character
	move $t0, $v0		#save input character to $t0
	
	beq $s0, $t0, empty 	#if user entered a * at the beginning create an empty list
	
	li $a0, 8		#store 8 into $a0 to allocate 8 bytes to a node
	li $v0, 9
	syscall			#allocate 8 bytes to memory
	
	move $t2, $v0		#store head of list in $t2 so we can return it later
	move $t1, $v0 		#store address of malloc to $t1
	sw $t0, 4($t1)		#save character to second half of node
	
loop:
	la $a0, charPrompt	#load prompt to $a0
	li $v0, 4
	syscall			#print prompt for getting next character
	
	li $v0, 12
	syscall 		#read character
	move $t0, $v0		#save input character to $t0
	
	beq $s0, $t0, tail	#if user entered a * then make tail
	
	li $a0, 8		#store 8 into $a0 to allocate 8 bytes to a node
	li $v0, 9
	syscall			#allocate 8 bytes of memory
	
	sw $v0, 0($t1)		#save location of current node in previous node
	move $t1, $v0		#store pointer to current node to $t1
	sw $t0, 4($t1)		#save character to second half of node
	j loop
tail:	
	move $v1, $t2		#save address of head to $v0 to return it
	jr $ra
empty:
	move $v1, $0
	jr $ra

#$a0 takes the address of the first node
#prints the contents of each node in order
print:
	move $t0, $a0		#save first node to $t0
	la $a0, newLine
	li $v0, 4
	syscall			#print new line before anything is printed
	move $a0, $t0		#put original $a0 back
	beq $a0, $0 endPrint
next:
	move $t0, $a0		#save current node to $t0
	lw $a0, 4($t0)		#load the character we need to print to $a0
	li $v0, 11
	syscall			#print the character
	la $a0, newLine		#load new line character to $a0
	li $v0, 4
	syscall			#print new line
	lw $a0, 0($t0)		#store address of next node to $a0
	beq $a0, $0, endPrint	#if there is no next node then just end procedure
	j next
endPrint:
	jr $ra			#return

reverse:
	beq $a1, $0, revEmpty	#if list is empty then return empty list
	lw $t0, 0($a1)		#save head to $t0
	beq $t0, $0, revOne	#if list has only one element we don't need to change anything
	sw $0, 0($a1)		#store next address in original head to null, as now it is the tail
	move $t2, $a1		#save head to $t2
revLoop:
	lw $t1, 0($t0)		#save the next node to $t0
	beq $t1, $0, endRev 	#if the next node is null then we are done
	sw $t2, 0($t0)		#store the previous cell address into current one
	move $t2, $t0		#current node is now the previous node
	move $t0, $t1		#next node is now current node
	j revLoop		#reverse next part of list
	
endRev:
	sw $t2, 0($t0)		#save address of final node
	move $v1, $t0
	jr $ra			#return
revEmpty:
	move $v1, $0		#return empty list
	jr $ra
revOne:
	move $v1, $a1		#make no changes
	jr $ra
#$a1 takes the address of the first node of a linked list
#reverses all the pointers in the linked list
#$v1 returns the address
