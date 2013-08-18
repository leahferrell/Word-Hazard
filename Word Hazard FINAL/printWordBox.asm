#Name: printWordBox
#Description: This functions to setup the 9-letter word box
#	      The input for this function is an address ($a0)
	.text
	
printWordBox:
	move	$t0, $a0
	
	la 	$a0, gridPrintTop
	li 	$v0, 4
	syscall
	
	la	$a0, menuLine0
	li	$v0, 4
	syscall
	
	la 	$a0, gridPrintSideLeft
	li 	$v0, 4
	syscall
	
	li	$v0, 11
	lb	$a0, 0($t0)
	syscall
	
	la 	$a0, gridPrintInside
	li 	$v0, 4
	syscall
	
	li	$v0, 11
	lb	$a0, 1($t0)
	syscall
	
	la 	$a0, gridPrintInside
	li 	$v0, 4
	syscall
	
	li	$v0, 11
	lb	$a0, 2($t0)
	syscall
	
	la 	$a0, gridPrintSideRight
	li 	$v0, 4
	syscall
	
	#### line two
	
	la	$a0, menuLine1
	li	$v0, 4
	syscall
	
	la 	$a0, gridPrintMiddle
	li 	$v0, 4
	syscall
	
	#### line three
	la	$a0, menuLine2
	li	$v0, 4
	syscall
	
	la 	$a0, gridPrintSideLeft
	li 	$v0, 4
	syscall
	
	li	$v0, 11
	lb	$a0, 3($t0)
	syscall
	
	la 	$a0, gridPrintInside
	li 	$v0, 4
	syscall
	
	li	$v0, 11
	lb	$a0, 4($t0)
	syscall
	
	la 	$a0, gridPrintInside
	li 	$v0, 4
	syscall
	
	li	$v0, 11
	lb	$a0, 5($t0)
	syscall
	
	la 	$a0, gridPrintSideRight
	li 	$v0, 4
	syscall
	
	#### line four
	la	$a0, menuLine3
	li	$v0, 4
	syscall
	
	la 	$a0, gridPrintMiddle
	li 	$v0, 4
	syscall
	
	#### line five
	la	$a0, menuLine4
	li	$v0, 4
	syscall
	
	la 	$a0, gridPrintSideLeft
	li 	$v0, 4
	syscall
	
	li	$v0, 11
	lb	$a0, 6($t0)
	syscall
	
	la 	$a0, gridPrintInside
	li 	$v0, 4
	syscall
	
	li	$v0, 11
	lb	$a0, 7($t0)
	syscall
	
	la 	$a0, gridPrintInside
	li 	$v0, 4
	syscall
	
	li	$v0, 11
	lb	$a0, 8($t0)
	syscall
	
	la 	$a0, gridPrintSideRight
	li 	$v0, 4
	syscall
	
	#### line five
	la	$a0, menuLine5
	li	$v0, 4
	syscall
	
	la 	$a0, gridPrintBottom
	li 	$v0, 4
	syscall
	
	la	$a0, menuLine6
	li	$v0, 4
	syscall
	
	jr	$ra
	

