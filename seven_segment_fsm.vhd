library ieee;
use ieee.std_logic_1164.all;

entity seven_segment_fsm is
	generic 
	(
		ADDR_WIDTH : natural := 6
	);
	port (
		seg_clk: in  	std_logic;
		reset:	in		std_logic;
		head:		in		natural range 0 to 2**ADDR_WIDTH - 1;
		tail:		out	natural range 0 to 2**ADDR_WIDTH - 1
	);
end entity seven_segment_fsm;


architecture ram_to_seg of seven_segment_fsm is
	-- Put signals here.
	type state_type is (read_data, set_display);
	signal state, next_state : state_type := start_adc;
	
	function snake_cond(
			h, t: in natural range 0 to 2**ADDR_WIDTH - 1
		) return boolean
	is
	begin
		if (t > h and t - h > 2) or (h > t and h - t < 2**ADDR_WIDTH - 1) then
			return true;
		else
			return false;
		end if;
	end function snake_cond;
	
	signal internal_tail: natural range 0 to 2**ADDR_WIDTH - 1;

begin
	tail <= internal_tail;
	-- store state
	store_state: process(seg_clk, reset) is
	begin
		if reset = '0' then
			state <= start_adc;
		elsif rising_edge(seg_clk) then
			state <= next_state;
		end if;
	end process store_state;
	
	--start 7seg
	start <= '1' when state = read_data else '0';
	
	--waiting for data
	set_state: process(state, head, internal_tail) is
	begin
		case state is
			when read_data =>
				if snake_cond(head, internal_tail) then
					next_state <= set_display;
				else
					next_state <= read_data;
				end if;
			when set_display => next_state <= read_data;
		end case
	end process set_state;

			


end architecture ram_to_seg;
