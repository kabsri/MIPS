# Name: Kabilan Sriranjan
# Student ID: 260671847

# Problem 3
# Numerical Integration with the Floating Point Coprocessor
###########################################################
.data
N: .word 100
a: .float 0
b: .float 0.5
error: .asciiz "error: must have low < hi\n"

.text 
###########################################################
main:
	# set argument registers appropriately
	l.s $f12, a		#a will be stored into $f0
	l.s $f13, b		#b will be stored into $f2
	la $a0, ident
	jal integrate
	# call integrate on test function 
	
	# print result and exit with status 0
	li $v0, 2
	mov.s $f12, $f0
	syscall			#print return value of integrate to screen
	
	li $v0, 17
	li $a0, 0
	syscall			#exit with status 0

###########################################################
# float integrate(float (*func)(float x), float low, float hi)
# integrates func over [low, hi]
# $f12 gets low, $f13 gets hi, $a0 gets address (label) of func
# $f0 gets return value
integrate: 
	addi $sp, $sp, -4	#make space for return adress on stack
	sw $ra, 0($sp)		#store return adress to stack
	jal check		#check if a and b are valid values
	
	# initialize $f4 to hold N
	lw $t0, N
	mtc1 $t0, $f4
	# since N is declared as a word, will need to convert
	cvt.s.w $f4, $f4
	
	sub.s $f6, $f13, $f12	#save b-a into $f6
	div.s $f6, $f6, $f4	#save (b-a)/n into $f6, this is the length of each subinterval
	
	li $t0, 2
	mtc1 $t0, $f8
	cvt.s.w $f8, $f8	#save 2.0 into $f8
	
	div.s $f8, $f6, $f8	#save (b-a)/2n into $f8
	add.s $f12, $f12, $f8	#save a+(b-1)/2n into $f12, the first point where we evaluate f(x)

loop:
	jalr $a0		#evaluate the function at $f12
	mul.s $f0, $f0, $f6	#multiply result by interval length
	add.s $f10, $f10, $f0	#add result to $f10, the cumulated result
	add.s $f12, $f12, $f6	#new x value to evaluate f(x)
	c.lt.s $f12, $f13	#if new x value is greater than b we are done
	bc1t loop
	
	mov.s $f0, $f10
	lw $ra 0($sp)		#load old return address back to stack
	addi $sp, $sp, 4	#restore stack
	jr $ra			#return

###########################################################
# void check(float low, float hi)
# checks that low < hi
# $f12 gets low, $f13 gets hi
# # prints error message and exits with status 1 on fail
check:
	c.lt.s $f12, $f13		#check if a<b
	bc1f failure		#go to failure if a not less than b
	jr $ra			#return if a<b
	
failure:
	la $a0, error		#load error message to $a0
	li $v0, 4
	syscall			#print error message
	li $v0, 17
	li $a0, 1
	syscall			#exit with status 1

###########################################################
# float ident(float x) { return x; }
# function to test your integrator
# $f12 gets x, $f0 gets return value
ident:
	mov.s $f0, $f12
	jr $ra
