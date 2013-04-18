# 
# Fibonacci Sequence Calculator
# 
# Displays the Fibonacci Sequence from 1 through 55
# - Then, clears LED board and restarts
# 

start:
	seti $1 0 # $1 = First number
	seti $2 1 # $2 = Second number
	seti $3 9 # Number of fibonacci sequence numbers to calculate

loop:
	# Place new number into $0
	seti $0 0
	add $0 $1
	add $0 $2
	
	# Move $2 -> $1
	seti $1 0
	add $1 $2
	
	# Move $0 -> $2
	seti $2 0
	add $2 $0
	
	# OUTPUT NUMBER
	# Need two registers so temporarily move $3 to memory
	seti $0 0 # Temp location
	sb $3 $0 # Move value
	
	# Output the number to the LED board
	seti $0 127 # Address of first LED
	add $0 $2 # Add the number we are displaying
	seti $3 1 # Need to store 1
	sb $3 $0 # Light up the LED at $0
	
	# Restore value of $3 from memory
	seti $0 0
	lb $3 $0
	
	# Loop check
	addi $3 -1
	bnz $3 loop
	bnz $2 end # Jump unconditionally to end

resetLEDs:
	# Reset the next LED
	addi $0 1 # $0 = Address of next LED
	sb $1 $0 # Store 0
	
	# See if that was just the last LED
	sub $0 $2 # $0 -= Address of last LED
	bz $0 start
	add $0 $2 # $0 = Address of last LED
	
	# Loop unconditionally
	bnz $0 resetLEDs

end:
	# SET UP THE RESET LEDS CODE
	seti $0 127 # $0 = Address of the first LED - 1
	seti $1 0 # $1 = Value to store into LED
	
	# $2 = Address of final LED
	seti $2 0
	add $2 $0
	addi $2 65
	
	# GO TO RESET LEDS
	bnz $2 resetLEDs # Jump unconditionally