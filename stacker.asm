start:
	seti $1 7 # The number of the row you are currently on
	seti $2 -1 # Last row blocks (11111111_2)
	seti $3 126 # Current row blocks (01111110_2)

loopLeft:
	# Poll button
	seti $0 -1 # Location of button in memory
	lb $0 $0 # Load value
	bnz $0 buttonPress
	
	# Shift LEFT!
	shift $3 -1
	
	# OUTPUT THE BLOCKS ONE-BY-ONE
	# Copy $3 into $0 
	seti $0 0
	add $0 $3
	
	# Update the current row register to represent the address of its corresponding LED row
	# $1 *= 8
	shift $1 -1
	shift $1 -1
	shift $1 -1
	
	# $1 += 127+8
	addi $1 127
	addi $1 8
	
	sb $3 $1
	shift $3 1
	
	addi $1 -1
	sb $3 $1
	shift $3 1
	
	addi $1 -1
	sb $3 $1
	shift $3 1
	
	addi $1 -1
	sb $3 $1
	shift $3 1
	
	addi $1 -1
	sb $3 $1
	shift $3 1
	
	addi $1 -1
	sb $3 $1
	shift $3 1
	
	addi $1 -1
	sb $3 $1
	shift $3 1
	
	addi $1 -1
	sb $3 $1
	
	# Restore the current row number
	addi $1 -127
	addi $1 -1
	shift $1 1
	shift $1 1
	shift $1 1
	
	# Restore the blocks
	add $3 $0 # $3 = $0 (because $3 is 0 right now)
	
	# Check if first bit is 1
	seti $0 -128 # $0 = 10000000_2
	and $0 $3 # Compare against current row blocks
	addi $0 127 # See if $0 == 10000000_2 (next line too)
	addi $0 1
	bz $0 loopRight # If first bit is 1, loop right
	
	# Continue loop
	bnz $3 loopLeft # Unconditionally jump to loopLeft

loopRight:
	# Poll button
	seti $0 -1 # Location of button in memory
	lb $0 $0 # Load value
	bnz $0 buttonPress
	
	# Shift RIGHT!
	shift $3 1
	
	# OUTPUT THE BLOCKS ONE-BY-ONE
	# Copy $3 into $0 
	seti $0 0
	add $0 $3
	
	# Update the current row register to represent the address of its corresponding LED row
	# $1 *= 8
	shift $1 -1
	shift $1 -1
	shift $1 -1
	
	# $1 += 127+8
	addi $1 127
	addi $1 8
	
	sb $3 $1
	shift $3 1
	
	addi $1 -1
	sb $3 $1
	shift $3 1
	
	addi $1 -1
	sb $3 $1
	shift $3 1
	
	addi $1 -1
	sb $3 $1
	shift $3 1
	
	addi $1 -1
	sb $3 $1
	shift $3 1
	
	addi $1 -1
	sb $3 $1
	shift $3 1
	
	addi $1 -1
	sb $3 $1
	shift $3 1
	
	addi $1 -1
	sb $3 $1
	
	# Restore the current row number
	addi $1 -127
	addi $1 -1
	shift $1 1
	shift $1 1
	shift $1 1
	
	# Restore the blocks
	add $3 $0 # $3 = $0 (because $3 is 0 right now)
	
	# Check if last bit is 1
	seti $0 1 # $0 = 00000001_2
	and $0 $3 # Compare against current row blocks
	addi $0 -1 # See if $0 == 00000001_2
	bz $0 loopLeft # If last bit is 1, loop left
	
	# Continue loop
	bnz $3 loopRight # Unconditionally jump to loopRight

buttonPress:
	# STACKER GAME ACTION
	# Block drops
	and $3 $2
	
	# See if they lost
	bz $3 lose
	
	# See if they won
	bz $1 win
	
	# OUTPUT THE BLOCKS FROM THE LAST ROW ONE-BY-ONE
	# Copy $3 into $0 
	seti $0 0
	add $0 $3
	
	# Update the current row register to represent the address of its corresponding LED row
	# $1 *= 8
	shift $1 -1
	shift $1 -1
	shift $1 -1
	
	# $1 += 127+8
	addi $1 127
	addi $1 8
	
	sb $3 $1
	shift $3 1
	
	addi $1 -1
	sb $3 $1
	shift $3 1
	
	addi $1 -1
	sb $3 $1
	shift $3 1
	
	addi $1 -1
	sb $3 $1
	shift $3 1
	
	addi $1 -1
	sb $3 $1
	shift $3 1
	
	addi $1 -1
	sb $3 $1
	shift $3 1
	
	addi $1 -1
	sb $3 $1
	shift $3 1
	
	addi $1 -1
	sb $3 $1
	
	# Restore the current row number
	addi $1 -127
	addi $1 -1
	shift $1 1
	shift $1 1
	shift $1 1
	
	# Move on to the next row
	addi $1 -1
	
	# Restore the blocks
	add $3 $0 # $3 = $0 (because $3 is 0 right now)
	
	# MOVE ON
	# Make the old blocks these new blocks
	seti $2 0
	add $2 $3
	bnz $1 buttonWait # Unconditionally jump to loopLeft

# This waits till they release the button to continue the loop.
# This way, the blocks are only dropped once on a button press
buttonWait:
	# Load button value
	seti $0 -1 # Location of button in memory
	lb $0 $0 # Load value
	
	# If it's zero, they already released the button. Continue.
	bz $0 loopRight
	
	# Otherwise, keep waiting!
	bnz $0 buttonWait

# Display frowny face
# * Designed by Nicole
# 0 0 0 0 0 0 0 0
# 0 0 0 0 0 0 0 0
# 0 0 1 0 0 1 0 0
# 0 0 0 0 0 0 0 0
# 0 1 1 1 1 1 1 0
# 0 1 0 0 0 0 1 0
# 0 0 0 0 0 0 0 0
# 0 0 0 0 0 0 0 0
lose:
	# DISPLAY SMILE FACE
	# Set up some registers
	seti $0 0 # $0 = 0 = Turn LED off
	seti $1 1 # $1 = 1 = Turn LED on
	seti $2 127 # $2 = address of first LED (- 1)
	
	# FIRST ROW
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	# SECOND ROW
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	# THIRD ROW
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $1 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $1 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	# FOURTH ROW
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	# FIFTH ROW
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $1 $2
	
	addi $2 1
	sb $1 $2
	
	addi $2 1
	sb $1 $2
	
	addi $2 1
	sb $1 $2
	
	addi $2 1
	sb $1 $2
	
	addi $2 1
	sb $1 $2
	
	addi $2 1
	sb $0 $2
	
	# SIXTH ROW
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $1 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $1 $2
	
	addi $2 1
	sb $0 $2
	
	# SEVENTH ROW
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	# EIGHTH ROW
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	# RESTART GAME
	bz $0 restart # Unconditionally jump to restart


# Display smile face
# * Designed by Nicole
# 0 0 0 0 0 0 0 0
# 0 0 0 0 0 0 0 0
# 0 0 1 0 0 1 0 0
# 0 0 0 0 0 0 0 0
# 0 1 0 0 0 0 1 0
# 0 1 1 1 1 1 1 0
# 0 0 0 0 0 0 0 0
# 0 0 0 0 0 0 0 0
win:
	# DISPLAY SMILE FACE
	# Set up some registers
	seti $0 0 # $0 = 0 = Turn LED off
	seti $1 1 # $1 = 1 = Turn LED on
	seti $2 127 # $2 = address of first LED (- 1)
	
	# FIRST ROW
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	# SECOND ROW
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	# THIRD ROW
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $1 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $1 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	# FOURTH ROW
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	# FIFTH ROW
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $1 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $1 $2
	
	addi $2 1
	sb $0 $2
	
	# SIXTH ROW
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $1 $2
	
	addi $2 1
	sb $1 $2
	
	addi $2 1
	sb $1 $2
	
	addi $2 1
	sb $1 $2
	
	addi $2 1
	sb $1 $2
	
	addi $2 1
	sb $1 $2
	
	addi $2 1
	sb $0 $2
	
	# SEVENTH ROW
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	# EIGHTH ROW
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	addi $2 1
	sb $0 $2
	
	# RESTART GAME
	bz $0 restart # Unconditionally jump to restart

restart:
	# Loop infinitely to keep the current state
	# Comment these next two lines if you want it to restart upon winning/losing
	seti $0 0
	bz $0 restart
	
	# CLEAR BOARD
	seti $0 127 # $0 = LED Address
	seti $1 0 # $1 = 0 (Turn LED off)
	
	# $2 = Address of final LED
	seti $2 0 # $2 = 0
	add $2 $0 # $2 = First LED address (- 1)
	addi $2 64 # $2 = Final LED address (- 1)
	
clearLoop:
	# LED stuff
	addi $0 1 # Get the next LED
	sb $1 $0 # Turn it off!
	
	# Loop stuff
	sub $0 $2 # $0 -= $2 (because we can only check if zero)
	bz $0 start
	add $0 $2 # Restore $0
	bnz $0 clearLoop # Jump unconditionally to clearLoop