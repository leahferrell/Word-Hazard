############################################################
#Macros
	
	#Gets the pointer to the z numbered string.
	#x is the register to PUT the pointer.
	#y is the pointer to the arrays zeroth entery.
	#z is the register with the number of the enerty wanted.
	.macro get_WordArray (%x, %y, %z) 
	sll $t7, %z, 2
	add $t7, %y, $t7
	lw %x, ($t7)
	.end_macro