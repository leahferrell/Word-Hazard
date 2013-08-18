# MIPSOTHON--- a simple word game program by Brendan Burns, Leah Ferrell, Suhrud Kulkarni, and Xi Zhang

	# IMPORTAINT!! For this program to run click, settings and check that PC intilzies on main if found, AND have the file "words.txt" is in the folder of mars and this program
	# as well any files in the .include's.
	.text
setupGame:
	add	$sp, $sp, -4
	sw	$ra, 0($sp)
	jal getFileName
	jal inportFile # fills the string dictionary with the word file.
	jal fillDictionaryArray #fills the pointers in this array!
	jal getNineLetter  #get the a random word AND RANDOMIZE!! :D	
	jal randomizeWord
	jal getKeyLetter
	
	lw	$ra, 0($sp)
	add	$sp, $sp, 4
	
	jr $ra


	
