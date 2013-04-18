# 
# LED Board Tester
# 
# 1) Turn on all the LEDs
# 2) Turn off all the LEDs
# 3) Repeat
# 

	# INITIALIZE
	# Turn on the LEDs
	seti $0 0 # Off now (so that it will be immediately changed to on)
	
	# The address of the final LED
	seti $2 127 # $2 = 127
	addi $2 64 # $2 = Address of final LED (-1 for branching purposes)

restart:
	# OUTPUT THE OPPOSITE VALUE
	bz $0 setOne # if ($0 == 0) $0 = 1
	seti $0 0 # else $0 = 0
	bz $0 restartContd
setOne:
	seti $0 1
restartContd: # Finish restarting
	# RESET LOOP VARIABLES
	seti $1 127 # Address of first LED - 1 (because we are going to add 1 right away)
	
loop:
	# Compute the address of the next LED
	addi $1 1
	
	# Turn on/off the corresponding LED
	sb $0 $1 # Set LED at $1 = on/off ($0)
	
	# See if that was just the last LED
	sub $1 $2 # $1 -= Address of last LED
	bz $1 restart
	add $1 $2 # $1 = Address of last LED
	
	bnz $2 loop # Jump unconditionally to loop