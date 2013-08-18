	.text
getUserInput:
	addi	$sp, $sp, -4
	sw	$ra, ($sp)
	la 	$a0, askForInput
	li 	$v0, 4
	syscall
	
	la 	$a0, userWord
	la 	$a1, userWord
	li 	$v0, 8
	syscall
	
	la	$a0, userWord
	lb	$t0, 0($a0)
	beq	$t0, '0', exitInput
	beq	$t0, '1', exitInputRand
	beq	$t0, '2', exitInputTime
	beq	$t0, '3', exitInputWords
	beq	$t0, '4', exitInputInstructions
	
	la	$a0, userWord		######
	jal	makeCaps		######
	
	addi	$v0, $0, 5
	j	getInputReturn
exitInputRand:
	addi	$v0, $0, 1
	j	getInputReturn
exitInputTime:
	addi	$v0, $0, 2
	j	getInputReturn
exitInputWords:
	addi	$v0, $0, 3
	j	getInputReturn
exitInputInstructions:
	addi	$v0, $0, 4
	j	getInputReturn
exitInput:
	add	$v0, $0, $0
getInputReturn:
	lw	$ra, ($sp)
	addi	$sp, $sp, 4
	jr	$ra
	
	
	
printUserInput:
	la	$a0, typedInText
	li	$v0, 4
	syscall
	
	jr	$ra
	
	
inputPlayAgain:
	la	$a0, runProgramAgainText	#ask the user if they want to play again
	li	$v0, 4
	syscall
getPlayAgainInput:	
	la 	$a0, userWord
	la 	$a1, userWord
	li 	$v0, 8
	syscall						#get the input

	la	$a0, userWord
	lb	$t0, 0($a0)
	beq	$t0, '0', exitPlayAgainFalse			#if the user types in 0, exit game
	beq	$t0, '1', exitPlayAgainTrue
	
	la	$a0, invalidPlayAgain
	li	$v0, 4
	syscall
	
	j	getPlayAgainInput
exitPlayAgainTrue:
	addi	$v0, $0, 1
	j	exitPlayAgain
exitPlayAgainFalse:
	add	$v0, $0, $0
exitPlayAgain:
	jr	$ra
