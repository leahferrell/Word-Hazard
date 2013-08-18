#This file contains the methods needed to read the dictionary file.


###################################################################################
#Gets the fileName
getFileName:
	li   $v0, 41       # random int
	syscall
	divu $t0, $a0, 26   #mod the length     
	mfhi $v0
	addi $v0, $v0, 'A'
	la $t1, fileName
	sb $v0, ($t1)		# store letter in fileName[0]
	sb $0, 1($t1)		# put null character in fileName[1]
	jr $ra




####################################################################################
#Function inports the file into the dictionary space.
inportFile:
	li   $v0, 13       # system call for open file
	la   $a0, fileName # board file name
	li   $a1, 0        # Open for reading
	li   $a2, 0    
	syscall            # open a file (file descriptor returned in $v0)
	move $s6, $v0      # save the file descriptor 
	li   $v0, 14      	 # system call for read from file
	move $a0, $s6      	# file descriptor 
	la   $a1, dictionary	# address of buffer to which to read
	li   $a2, 500000     	# hardcoded buffer length
	syscall            	# read from file
	li   $v0, 16       # system call for close file
	move $a0, $s6      # file descriptor to close
	syscall            # close file
	jr $ra

######################################################################################
#fillDictionaryArray fills the array of pointers 
fillDictionaryArray:
	la $a0, dictionary	#Scanner
	la $a1, dictionaryArray
	sw $a0, ($a1)		#Store scanner pos as pointer in dictionaryArray    [Leah: So.... it starts at an '*'?]
	add $v1, $0, $0		#initialize to 0 [Leah: Added by me]
	add $v1, $v1, 1		#add 1 to the number of words.		[Leah: Find out what is in $v1]
	add $a1, $a1, 4		#Move the dictionaryArray point over to next storing location
fillDictionaryArrayLoop:
	lb $t0, ($a0) #loads byte from dictionary
	beq $t0, 0, fillDictionaryArrayReturn #return if it hits a null character (0)
	bne $t0, 10, fillSkipped #go other way if failed.
	sb $zero, ($a0)		#replaces the new line with null
	add $a0, $a0, 1		#Advances the scanner
	sw $a0, ($a1)		#Store scanner pos as pointer in dictionaryArray
	add $a1, $a1, 4		#Move the dictionaryArray point over to next storing location
	add $v1, $v1, 1		#add 1 to the number of words.
	j fillDictionaryArrayLoop
fillSkipped:
	add $a0, $a0, 1		#Advances the scanner
	j fillDictionaryArrayLoop
fillDictionaryArrayReturn:
	sw $v1, lengthOfList
	jr $ra
	
	
	
######################################################################################
#Gets a nine letter word and fills the box with it.
getNineLetter:
	subi $sp, $sp, 4
	sw $ra, ($sp)  
	la $s1, dictionaryArray
getNineLetterLoop:
	lw $a0, lengthOfList
	jal randNumber
	move $s2, $v0
	get_WordArray ($a0, $s1, $s2)
	jal getLength
	beq $v1, 10, getNineLetterFinish
	j getNineLetterLoop
getNineLetterFinish:
	la $s3, wordInBox
	move $s4, $s2
	get_WordArray ($s2, $s1, $s2)
	li $t0, 0
getNineLetterFinishLoop:
	beq $t0, 11, fillDictionaryArrayCorrect
	lb $t1, ($s2)
	sb $t1, ($s3)
	add $s3, $s3, 1
	add $s2, $s2, 1
	add $t0, $t0, 1
	j getNineLetterFinishLoop
fillDictionaryArrayCorrect:
	
fillDictionaryArrayCorrectFindTopLoop:	
	addi $s4, $s4, -1
	get_WordArray ($a0, $s1, $s4)
	lb $t0 ($a0)
	beq $t0, '*', fillDictionaryArrayCorrectTopFound
	j fillDictionaryArrayCorrectFindTopLoop
fillDictionaryArrayCorrectTopFound:
	li $t0, 0
	addi $s4, $s4, 2
	la $s5, correctWordsPointerArray
fillDictionaryArrayCorrectLoop:
	get_WordArray ($a0, $s1, $s4)  #<--------------------
	lb $t0 ($a0)
	beq $t0, '*', fillDictionaryArrayCorrectReturn
	get_WordArray ($a0, $s1, $s4)
	
	sw $a0, ($s5)


	lw	$t4, totalPossibleWords			######[Leah: added here]
	addi	$t4, $t4, 1
	sw	$t4, totalPossibleWords
	
	addi $s4, $s4, 1
	addi $t0, $t0, 1
	addi $s5, $s5, 4
	
	j fillDictionaryArrayCorrectLoop
	

	
fillDictionaryArrayCorrectReturn:
	sw $t0, lengthOfList

getNineLetterReturn:
	lw $ra, ($sp) 
	addi $sp, $sp, 4
	jr $ra
	
	
	
##############################################################################################
#exacutes a ranomization of the Word in the box.
randomizeWord:
	addi	$sp, $sp, -4
	sw	$ra, ($sp)
	la	$s1, wordInBox
	add	$t0, $0, $0		# intialize i = 0 in t0
randomizeWordLoop:
	beq	$t0, 9, randomizeWordReturn #count up to 9 and exit when it hits 9
	
	beq	$t0, 4, randomizeIncreaseCounter
	
	#generate random number in t1
	li	$v0, 30
	syscall
	move	$a1, $a0
	li	$a0, 4
	li	$v0, 40
	syscall
	li	$a0, 4
	li	$v0, 41
	syscall
	add	$t1, $a0, $0		# random number in t1
	addi	$t2, $0, 9		#mod by 9
	
	divu	$t1, $t2		#divide the numbers
	mfhi	$t1			#move from hi to get remainder
	
	bne	$t1, 4, continueRandomization
	j	randomizeWordLoop
continueRandomization:	
	beq	$t0, $t1, randomizeWordLoop #if that's the same as t0, jump to randomizewordloop2, else, switch characters
	
	lb 	$t2, wordInBox($t0)	#load character at t0 into t2
	lb 	$t3, wordInBox($t1)	#load character at t1 into t3
	sb 	$t3, wordInBox($t0)	#store character in t3 into location at t0
	sb 	$t2, wordInBox($t1)	#store character in t2 into location at t1
randomizeIncreaseCounter:
	addi	$t0, $t0, 1
	j	randomizeWordLoop
randomizeWordReturn:	
	lw	$ra, ($sp)
	addi	$sp, $sp, 4	
	jr	$ra

	
#######################################################
#Does what it says.
getKeyLetter:
	la $t1, wordInBox
	lb $t1, 4($t1)
	sb $t1, keyLetter
	jr $ra 



