#Name: validateInput
#Description: This takes the user's entered word, an array of pointers to correct words, and determines whether the user's word is correct
#	      by comparing to the correct words. It returns a 1 if true (valid) and 0 if false (not valid)

	.text

#######################################- validateInput() -###########################################
# For simplicity, I made correctWordsPointerArray registers $s# and userInput registers $t#
validateInput:
	add	$s1, $0, $0		#initiate possibleWords counter to 0 (only initialize once)
validateInputNextWord:
	add	$t1, $0, $0		#initialize userWord counter to 0 each time it is compared to a new word
validateInputLoop:		
	la	$t0, userWord		#load the user's word
	lw	$s0, correctWordsPointerArray($s1) #load current possibleWord
	beq	$s0, 0, validateInputExitFalse
	bne	$s0, 1, validateInputCont
	addi	$s1, $s1, 4
	j	validateInputNextWord 
validateInputCont:	
	add	$t2, $t1, $t0		#add counter to userWord[0] to get next byte
	add	$s2, $t1, $s0		#add counter to possibleWord to get next byte
	lb	$t3, 0($t2)		#load next byte - FROM USER
	lb	$s3, 0($s2)		#load next byte - FROM POSSIBLE WORDS
	
	beq	$t3, $0, validateInputExitCondition #if there are no more chars in userWord, check if there are anymore in the possibleWord
	beq	$t3, '\n', validateInputExitCondition

	beq	$s3, $0, validateInputCheckNext #if there are no more chars in the possibleWord, exit via false
	
	bne	$t3, $s3, validateInputCheckNext #if the characters aren't equal, exit via false
	
	addi	$t1, $t1, 1		#increase the counter
	j	validateInputLoop

validateInputExitCondition:
	beq	$s3, $0, validateInputExitTrue
	beq	$s3, '\r', validateInputExitTrue
validateInputCheckNext:
	addi	$s1, $s1, 4
	j	validateInputNextWord
	
validateInputExitFalse:
	la	$a0, incorrectInput
	li	$v0, 4
	syscall

	add	$v0, $0, $0
	j	validateInputExit
validateInputExitTrue:
	la	$a0, correctEntryText
	li	$v0, 4
	syscall
	
	sw	$s0, correctWords($s1)	#move string pointer over to correctWords #### THIS ONE IS FROM THE USER [Leah]
	li	$t0, 1
	sw	$t0, correctWordsPointerArray($s1) #### THIS ONE IS FROM THE DICTIONARY
		
	addi	$v0, $0, 1
validateInputExit:
	jr	$ra
	
####################################- printPossibleWords() -#########################################	
printPossibleWords:
	add	$t1, $0, $0

printPossibleWordsLoop:
	lw	$t0, correctWordsPointerArray($t1)
	beq	$t0, 0, printPossibleExit	
	bne	$t0, 1, printWord
	addi	$t1, $t1, 4
	j	printPossibleWordsLoop
printWord:
	lb	$t2, 0($t0)
	
	la	$a0, ($t0)
	li	$v0, 4
	syscall
	
	la	$a0, newLineChar
	li	$v0, 4
	syscall
	
	addi	$t1, $t1, 4
	j	printPossibleWordsLoop
printPossibleExit:
	jr	$ra
	
####################################- printCorrectWords() -#########################################	

printCorrectWords:
	add	$t1, $0, $0

printCorrectWordsLoop:
	lw	$t0, correctWords($t1)
	beq	$t0, 0, printCorrectExit	
	bne	$t0, 1, printCorrectWord
	addi	$t1, $t1, 4
	j	printCorrectWordsLoop
printCorrectWord:
	lb	$t2, 0($t0)
	
	la	$a0, ($t0)
	li	$v0, 4
	syscall
	
	la	$a0, newLineChar
	li	$v0, 4
	syscall
	
	addi	$t1, $t1, 4
	j	printCorrectWordsLoop
printCorrectExit:
	jr	$ra		
	
####################################- clearCorrectWords() -#########################################
# initializes every pointer to 1
clearCorrectWords:
	add	$t1, $0, $0
clearCorrectWordsLoop:
	beq	$t1, 9996, clearCorrectWordsExit
	lw	$t0, correctWords($t1)
	addi	$t0, $0, 1
	sw	$t0, correctWords($t1)
	add	$t1, $t1, 4
	j	clearCorrectWordsLoop
clearCorrectWordsExit:
	sw	$0, correctWords($t1)
	jr	$ra
	
####################################- takeOutNonMidLetter() -#########################################	

takeOutNonMidLetter:
	addi	$sp, $sp, -4
	sw	$ra, ($sp)
	add	$t3, $0, $0

takeOutLoop:
	lw	$t0, correctWordsPointerArray($t3)
	beq	$t0, 0, takeOutExit	#Exit if hit null pointer
	bne	$t0, 1, takeOutWordTest #If != 1, check word for mid letter
	addi	$t3, $t3, 4		#increase counter by 4
	j	takeOutLoop		#jump to beginning
takeOutWordTest:
	move	$a0, $t0		#load string into a)
	jal	HasKeyLetterScan	#check for key letter
	beq	$v1, $0, takeOutWord	#if not present, take out word, else jump back to top of loop
	addi	$t3, $t3, 4		#increase counter by 4
	j	takeOutLoop
takeOutWord:
	li	$t2, 1			#load 1 in t2
	sw	$t2, correctWordsPointerArray($t3) #store 1 in array
	lw	$t4, totalPossibleWords			######[Leah: added here]
	addi	$t4, $t4, -1
	sw	$t4, totalPossibleWords
	addi	$t3, $t3, 4		#increase counter by 4
	j	takeOutLoop
takeOutExit:
	lw	$ra, ($sp)
	addi	$sp, $sp, 4
	jr	$ra
