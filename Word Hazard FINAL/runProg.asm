
	.text
	.globl main
	
	.include "macros.asm"
	.include "importing.asm"
	.include "WordTests.asm"
	.include "setup.asm"
	.include "printInstructions"
	.include "printWordBox.asm"
	.include "getInput.asm"
	.include "scoring.asm"
	.include "timeFunction.asm"
	.include "validateInput.asm"

main:	
	
playAgain:	
	sw	$0, totalPossibleWords
	sw	$0, totalTime
	sw	$0, score
	sw	$0, numWordsEnteredCorrect
	li	$t1, 60
	sw	$t1, totalLeft
	
	jal	setupGame
	jal 	printInstructions
	
	la 	$a0, startInput
	la 	$a1, startInput
	li 	$v0, 8
	syscall
	
	jal 	getCurrentTime
	sw	$v0, startTime
	
	jal	clearCorrectWords
	jal	takeOutNonMidLetter
	
	jal	runProgram
	
	lw	$a0, startTime
	jal	getTimeElapsed
	sw	$v0, totalTime
	
	jal 	displayFinalScore
	
	la	$a0, printCorrectWordsText	#print corrrect words
	li	$v0, 4
	syscall
	
	jal	printCorrectWords
	
	la	$a0, printMissedWordsText
	li	$v0, 4
	syscall

	jal	printPossibleWords
	jal	inputPlayAgain		#ask the user if they want to play again
	
	bne	$v0, $0, playAgain		#if 0, exit
	
	li	$v0, 10			#Exit the program here
	syscall
	
	
runProgram:
	addi	$sp, $sp, -4
	sw	$ra, 0($sp)
	
runProgramLoop:
	lw	$t0, numWordsEnteredCorrect
	lw	$t1, totalPossibleWords
	
	beq	$t0, $t1, enteredAllCorrectWords

	la 	$a0, wordInBox
	jal 	printWordBox
	
	beq	$s5, 1, runProgramSkipTime
	sw	$0, beginTime		#initialize to 0 each time
	
	jal 	getCurrentTime
	sw	$v0, beginTime
	
runProgramSkipTime:	
	jal	getUserInput
	add	$s5, $v0, $0
	
	beq	$s5, $0, runProgramEnd	#checks first for whether or not the user enters in a 0
	beq	$s5, 1, runProgramRandom
	beq	$s5, 2, runProgramDisplayTime
	beq	$s5, 3, runProgramDisplayEntered
	beq	$s5, 4, runProgramInstructions
	
	jal	validateInput		######### <------ Xi, here is where validation stuff is called
	
	bne	$v0, $0, runCorrectEntry#if 0: invalid, else 1: valid
runIncorrectEntry:
	lw	$a0, beginTime
	jal	getTimeElapsed
	
	add	$t1, $v0, $0
	
	add	$a1, $t1, $0
	lw	$a0, totalLeft		#storing the total time in seconds
	jal	notValidUpdateScore
	beq	$v0, $0, runProgramEnd
	j	runProgramLoop
runCorrectEntry:	
	lw	$a0, beginTime
	jal	getTimeElapsed
	add	$t0, $v0, $0
	
	lw	$a0, wordLength
	lw	$a1, score		#storing the score
	lw	$a2, totalLeft		#storing the total time in seconds
	add	$a3, $0, $t0		#time it took in seconds
	jal	updateScore
	beq	$v0, $0, runProgramEnd
	
	j	runProgramLoop
	
enteredAllCorrectWords:
	la	$a0, exitByGetAllWords
	li	$v0, 4
	syscall

runProgramEnd:
	jal	printUserInput
	
	lw	$ra, 0($sp)
	addi	$sp, $sp, 4
	jr	$ra
runProgramRandom:
	jal	randomizeWord
	j	runProgramLoop
runProgramDisplayTime:
	la	$a0, timeText
	li	$v0, 4
	syscall
	
	lw	$a0, beginTime		#
	jal	getTimeElapsed		#
	add	$t0, $v0, $0		#
	
	
	lw	$t1, totalLeft
	sub	$t1, $t1, $t0
	sw	$t1, totalLeft
	
	ble	$t1, $0, runProgramEnd
	
	move	$a0, $t1
	li	$v0, 1
	syscall
	
	la	$a0, secondsText
	li	$v0, 4
	syscall
	
	j	runProgramLoop
runProgramDisplayEntered:
	la	$a0, printCorrectWordsText	#print corrrect words
	li	$v0, 4
	syscall
	
	jal	printCorrectWords
	j	runProgramLoop
runProgramInstructions:
	jal 	printInstructions
	la 	$a0, startInput
	la 	$a1, startInput
	li 	$v0, 8
	syscall
	
	j	runProgramLoop

###########################################################################################################################	
###########################################################################################################################	
#####################- data from all the included files is here and labeled according to file name -#######################		
###########################################################################################################################		
###########################################################################################################################

	 	 
	.data
################################################## - From printInstructions
directionsText1:
	.asciiz "Welcome to Word Hazard!\n"
directionsText2:
	.asciiz "This is a word game modeled after the popular Android game, Lexathon!\n\n"
directionsText3:
	.asciiz "The goal is to find as many words of four or more letters in the given time.\n"
directionsText4:
	.asciiz "The user is also required to incorporate the middle letter in their entered word.\n\n"
directionsText5:
	.asciiz "The game starts with 60 seconds and each time a correct word is entered,\n"
directionsText6:
	.asciiz "the time increases by 20 seconds. The remaining time is displayed to the user after\n"
directionsText7:
	.asciiz "each correct entry.\n\n"
directionsText8:
	.asciiz "The game ends when the time runs out or you give up (by typing 0).\n\n"
directionsText9:
	.asciiz "The score is determined by the percentage of words found and the speed in which they are found.\n"
directionsText10:
	.asciiz "Ready to begin? (Press any key)\n"
	
################################################## - From printWordBox.asm
gridPrintTop:
	.asciiz "\n\t.---.---.---.\t\t"
gridPrintMiddle:
	.asciiz "\t|---+---+---|\t\t"
gridPrintBottom:
	.asciiz "\t'---'---'---'\t\t"
gridPrintSideLeft:
	.asciiz "\t| "
gridPrintSideRight:
	.asciiz " |\t\t"
gridPrintInside:
	.asciiz " | "

menuLine0:
	.asciiz ".	Menu:			.\n"
menuLine1:
	.asciiz "|  0:	Exit game		|\n"
menuLine2:
	.asciiz "|  1:	Shuffle letters		|\n"
menuLine3:
	.asciiz "|  2:	Display time remaining	|\n"
menuLine4:
	.asciiz "|  3:	Display words entered	|\n"
menuLine5:
	.asciiz "|  4:	Display Instructions	|\n"
menuLine6:
	.asciiz "'				'\n"
	
################################################## - From getInput.asm	
askForInput:
	.asciiz "Enter in a word:\n"
typedInText:
	.asciiz "Good Game!\n"
userWord:
	.align 2
	.space 10
startInput:
	.word 0

	
################################################## - From scoring.asm	
startText:
	.asciiz "This tests the scoring subroutine\n"
secondsText:
	.asciiz " seconds\n"
scoreText:
	.asciiz "Score: "
timeText:
	.asciiz "\nTime remaining: "
finalScoreText: 
	.asciiz "\nYour final score is: "
totalTimeText:
	.asciiz "\nTotal time: "
timeTestText:
	.asciiz "Your entry took: "
wPMText:
	.asciiz "Words per minute: "
percentFoundText:
	.asciiz "\nPercentage of words found: "
exitByOutOfTime:
	.asciiz "Out of Time!\n"
exitByGetAllWords:
	.asciiz "Congratulations! You found all the words!\n"
wordsFoundSoFar1:
	.asciiz "You have found "
wordsFoundSoFar2:
	.asciiz " so far!\n"
close:
	.asciiz "%)\n"
	
newLineChar:
	.asciiz "\n"
score:
	.word 0
wordLength:
	.word 6
totalTime:
	.word 0
totalLeft:
	.word 60

	.align 2
beginTime:
	.word 0
	
statusTime:
	.word 0
	
numWordsEnteredCorrect:
	.word 0
totalPossibleWords:
	.word 0
openParenthesis:
	.asciiz "("
slash:
	.asciiz "/"
percent:
	.word 0

################################################## - From timeFunction.asm	
.space 4
startTime: .word 
.space 4
endTime: .word
.space 4
currentTime: .word
printTimeDisplay: .asciiz ""
myWord: .space 10

##################################################	#From Project.asm

	.align 0
strspace: .asciiz " "
newline: .asciiz "\n"
wordstyped: .asciiz "The correct words you entered are: \n"
wordsleft: .asciiz ": \n "
correctEntryText: .asciiz "\nIt's about time you got a word right!\n"
wordsEnteredCorrect:
	.align 2
	  .space 1000
numwordsEnteredCorrect: 
	.align 2
	.word 0
numwordsMissed: 
	.align 2
	.word 0
enteredword : 
	.align 2
	.space 10
missedWordsArray:
	.align 2
	  .space 1000
incorrectInput: .asciiz "Come on, now! That is not correct! (Make sure you're using the middle letter)\n"
wordsUserMissed: .asciiz "\n The words you missed are: \n"	
thisWordIsRepeated: .asciiz "You have already entered this word!\n"
fileName:
	.asciiz	"    "
dictionary:
	.space 500000
dictionaryArray:
	.align	2
	.space 368000
correctWordsPointerArray:
	.align	2
	.space 10000
lengthOfList:
	.word	0
wordInBox:
	.align	0
	.space 10
lettersInBox:
	.space 26
lettersInInput:
	.space 26
keyLetter:
	.byte 'A'
endline:
	.asciiz "----"

##################################################	#FROM validateInput.asm

correctWords:
	.space 10000
printCorrectWordsText:
	.asciiz "The correct words you entered are: \n"
printMissedWordsText:	
	.asciiz "\nThe words you missed are: \n"

################################################## - Extra variables
	.align 2
runProgramAgainText:
	.asciiz "Good job! Would you like to play again? (1: yes, 0: no)\n"	
	
invalidPlayAgain:
	.asciiz "Invalid entry. Please enter 1 to play again or 0 to exit\n"
