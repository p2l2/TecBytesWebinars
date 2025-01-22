# PLL Constraints
#################
create_clock -period 19.9253 -waveform {9.9626 19.9253} [get_ports {Clk}]

# GPIO Constraints
####################
# set_input_delay -clock <CLOCK> -max <MAX CALCULATION> [get_ports {BTN1}]
# set_input_delay -clock <CLOCK> -min <MIN CALCULATION> [get_ports {BTN1}]
# set_input_delay -clock <CLOCK> -max <MAX CALCULATION> [get_ports {BTN2}]
# set_input_delay -clock <CLOCK> -min <MIN CALCULATION> [get_ports {BTN2}]
# set_input_delay -clock <CLOCK> -max <MAX CALCULATION> [get_ports {PLL_IN}]
# set_input_delay -clock <CLOCK> -min <MIN CALCULATION> [get_ports {PLL_IN}]
# set_output_delay -clock <CLOCK> -max <MAX CALCULATION> [get_ports {LED1}]
# set_output_delay -clock <CLOCK> -min <MIN CALCULATION> [get_ports {LED1}]
# set_output_delay -clock <CLOCK> -max <MAX CALCULATION> [get_ports {LED2}]
# set_output_delay -clock <CLOCK> -min <MIN CALCULATION> [get_ports {LED2}]
# set_output_delay -clock <CLOCK> -max <MAX CALCULATION> [get_ports {LED3}]
# set_output_delay -clock <CLOCK> -min <MIN CALCULATION> [get_ports {LED3}]
set_output_delay -clock Clk -max -3.903 [get_ports {LED4}]
set_output_delay -clock Clk -min -1.784 [get_ports {LED4}]
