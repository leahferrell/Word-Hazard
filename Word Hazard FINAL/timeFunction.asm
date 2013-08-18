.text
getCurrentTime:
	li	$v0, 30				#syscall 30
	syscall					#now $a0 has lower 32 bits of system time
	li	$t0, 1000			#convert system time from milliseconds to seconds
	div	$a0, $t0			#lo holds seconds
	mflo	$v0				#return seconds
	jr	$ra
				
getTimeElapsed:					#parameter is $a0 (start)
	addi	$sp, $sp, -8
	sw	$ra, ($sp)
	sw	$a0, 4($sp)
	jal	getCurrentTime			#find currentTime, and get it on $v0
	lw	$t0, 4($sp)			#load startTime onto $t0
	lw	$ra, ($sp)
	addi	$sp, $sp, 8
	sub	$v0, $v0, $t0			#get difference in time
	jr	$ra
