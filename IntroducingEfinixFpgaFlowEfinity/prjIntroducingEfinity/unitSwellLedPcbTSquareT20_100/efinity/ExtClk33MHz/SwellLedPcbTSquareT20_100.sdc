# Device: T8F81
# Project: efinix
# Timing Model: C2 (final)

# PLL Constraints
# These constraints do constrain PLL outputs. We have slightly less than 40 MHz
# at the output thus:
#################
create_clock -period 25.0784 -waveform {12.5392 25.0784} [get_ports {PLL_OUT}]

# GPIO Constraints
####################
# All outputs go to LEDs for human interaction where timing is of no interest
set_false_path -to [get_ports {D400 D401 D402 D404 Dnone} ]
# All inputs source from input keys which are asynchronous to the internal clock 
# and have to be synchronized.
set_false_path -from [get_ports {S100 S101} ]