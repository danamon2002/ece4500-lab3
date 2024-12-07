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
	signal state, next_state : state_type := read_data;
	
	constant top_address: positive := 2**ADDR_WIDTH - 1;
	
	function snake_cond(
    h, t: in natural range 0 to 2**ADDR_WIDTH - 1
		) return boolean
	is
	begin
		 -- If true, go to write_data
		 -- If false, go to check_space
		 -- If Head has reached max buffer size, set head to 0
		if h > t and h - t > 1 then
			return true;
		elsif t > h and not (t = top_address and h = 1) then
			return true;
		elsif t > h and not (t = top_address - 1 and h = 0) then
			return true;
		end if;
		
		return false;
		 
	 
	end function snake_cond;
	
	signal internal_tail: natural range 0 to 2**ADDR_WIDTH - 1;

begin
	tail <= internal_tail;
	-- store state
	store_state: process(seg_clk, reset) is
	begin
		if reset = '0' then
			state <= read_data;
		elsif rising_edge(seg_clk) then
			state <= next_state;
		end if;
	end process store_state;
	
	
	--waiting for data (loop)
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
		end case;
	end process set_state;

	output_state: process(seg_clk, reset) is
	begin
		if reset = '0' then
			internal_tail <= 2**ADDR_WIDTH - 2;
		elsif rising_edge(seg_clk) then
			if state = set_display then
				if internal_tail = 2**ADDR_WIDTH - 1 then
					internal_tail <= 0;
				else
					internal_tail <= internal_tail + 1;
				end if;
			end if;
		end if;
	end process output_state;



end architecture ram_to_seg;
