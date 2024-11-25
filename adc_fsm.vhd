library ieee;
use ieee.std_logic_1164.all;

entity adc_fsm is
	generic 
	(
		ADDR_WIDTH : natural := 6
	);
	
	port (
		adc_clk: in  	std_logic;
		tail:		in		std_logic_vector(ADDR_WIDTH downto 0);
		eoc:		in		std_logic;
		store:	out	std_logic;
		start:	out 	std_logic;
		head:		out	std_logic_vector(ADDR_WIDTH downto 0);
	);


architecture adc_to_ram of adc_fsm is
	-- Put signals here.
begin