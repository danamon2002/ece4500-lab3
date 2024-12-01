library ieee;
use ieee.std_logic_1164.all;

entity seven_segment_fsm is
	generic 
	(
		ADDR_WIDTH : natural := 6
	);
	port (
		seg_clk: in  	std_logic;
		head:		in		natural range 0 to 2**ADDR_WIDTH - 1;
		tail:		out	natural range 0 to 2**ADDR_WIDTH - 1;
	);
end entity seven_segment_fsm;


architecture fsm of seven_segment_fsm is
	-- Put signals here.
begin

end architecture fsm;
