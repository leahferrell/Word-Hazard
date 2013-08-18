#Has all the words checking functions
	
############################################################################################
#takes a string at $a0 and reads the length.
#t0 is scanner, t1 is couter, t2 is scanners held value.
#Retuns length in v1 
getLength:
	add $t0, $a0, $zero
	li $t1, 0
getLengthLoop:	
	lb $t2, ($t0)
	beq $t2, 0, getLengthReturn
	add $t1, $t1, 1 #advance counter
	add $t0, $t0, 1 #advance scanner
	j getLengthLoop
getLengthReturn:
	move $v1, $t1
	jr $ra
	
############################################################################################
#Takes String at $a0 and makes it into a all caps string.
makeCaps:
	add $t0, $a0, $zero
makeCapsLoop:
	lb $t2, ($t0)
	beq $t2, 0, makeCapsReturn
	ble $t2, 'Z', makeCapsIsCap
	sub $t2, $t2, 'a'
	add $t2, $t2, 'A'
	sb $t2, ($t0)
makeCapsIsCap:
	add $t0, $t0, 1 #advance scanner
	j makeCapsLoop
makeCapsReturn:
	jr $ra	
	
############################################################################################
#Takes a string at $a0, and determine if it is infact a vailid input.	
#retunrs true or flase, in v1
isValidInput:
	add $t0, $a0, $zero
isValidInputLoop:
	lb $t2, ($t0)
	beq $t2, 0, isValidInputPass
	blt $t2, 'A', isValidInputFail
	bgt $t2, 'z', isValidInputFail
	bgt $t2, 'Z', isValidCheck
	add $t0, $t0, 1 #advance scanner
	j isValidInputLoop
isValidCheck:
	blt $t2, 'a', isValidInputFail
	add $t0, $t0, 1 #advance scanner
	j isValidInputLoop
isValidInputFail:
	li, $v1, 0
	jr $ra
isValidInputPass:
	li, $v1, 1
	jr $ra
	
	
	
############################################################################################
#will fill the fillLetterArray at a0 with the information from the string at a1
fillLetterArray:
	subi $sp, $sp, 4
	sw $ra, ($sp)  
	jal ClearLetterArray
	add $t0, $a1, $zero
fillLetterArrayLoop:
	lb $t1, ($t0)
	beq $t1, 0, fillLetterArrayReturn	
	sub $t1, $t1, 'A'
	add $t1, $t1, $a0
	lb $t2, ($t1)
	add $t2, $t2, 1
	sb $t2, ($t1)
	add $t0, $t0, 1 #advance scanner
	j fillLetterArrayLoop
fillLetterArrayReturn:
	lw $ra, ($sp) 
	addi $sp, $sp, 4
	jr $ra
	
	
	
############################################################################################
#Clears the letterArray at a1.	
ClearLetterArray:
	add $t0, $a0, $zero	
	li $t1, 0
ClearLetterArrayLoop:
	beq $t1, 26, ClearLetterArrayReturn
	add $t1, $t1, 1
	sb $zero, ($t0) 
	add $t0, $t0, 1 #advance scanner
	j ClearLetterArrayLoop
ClearLetterArrayReturn:
	jr $ra



############################################################################################
#checks if the LetterArray a1 is in LetterArray a0
CompareLetters:
	li $t0, 0 #CompareLetters line 1
CompareLettersLoop:
	beq $t0, 26, CompareLettersPass
	add $t1, $a0, $t0
	add $t2, $a1, $t0
	lb $t2, ($t2)
	lb $t1, ($t1)
	bgt $t2, $t1, CompareLettersFail
	add $t0, $t0, 1 #advance scanner
	j CompareLettersLoop
CompareLettersPass:
	li $v1, 1
	jr $ra
CompareLettersFail:
	li $v1, 0
	jr $ra


############################################################################################
#Takes words at a0 and a1 and returns if they are the same $v1=0 or diffrebt $v1=1
diffrentWord:
	li $t0, 0 #Sanner pos
diffrentWordLoop:
	add $t1, $a0, $t0
	add $t2, $a1, $t0
	lb $t1, ($t1)
	lb $t2, ($t2)
	beq $t1, 0, diffrentWordCheck
	bne $t2, $t1, diffrentWordPass
	add $t0, $t0, 1 #advance scanner
	j diffrentWordLoop
diffrentWordCheck:
	beq $t2, 0, diffrentWordFail
diffrentWordPass:
	li $v1, 1
	jr $ra
diffrentWordFail:
	li $v1, 0
	jr $ra

############################################################################################
#Will see if string a0 has the keyLetter
HasKeyLetterScan:
	li $t0, 0 #Sanner pos for HasKeyLetterScan
	lb $t1, keyLetter
HasKeyLetterScanLoop:
	add $t2, $a0, $t0
	lb $t2, ($t2)
	beq $t2, 0, HasKeyLetterScanFail
	beq $t1, $t2, HasKeyLetterScanPass
	add $t0, $t0, 1 #advance scanner
	j HasKeyLetterScanLoop
HasKeyLetterScanPass:
	li $v1, 1
	jr $ra
HasKeyLetterScanFail:
	li $v1, 0
	jr $ra

###########################################################################################
#a0 gives the upper limit too use. v0 is the output.
randNumber:
	move $t1, $a0
	li   $v0, 41       # random int
	syscall
	divu $t0, $a0, $t1   #mod the length        
	mfhi $v0
	jr $ra
	
	
	
