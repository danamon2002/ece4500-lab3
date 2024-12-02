% main 50 MHz clock
create_clock -period 0.00000002 [ get_ports main_clock ]
create_clock -period 0.00000002 -name main_clock_virt

% ADC 10 MHz clock
create_clock -period 0.0000001 [ get_ports adc_clock ]
create_clock -period 0.0000001 -name adc_clock_virt

% ADC derived clock
create_generated_clock -name clk_div -source [ get_pins inst|clk ] \
	-divide_by 10 -multiply_by 1 [ get_pins inst|q ]