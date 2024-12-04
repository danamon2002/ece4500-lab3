library ieee;
use ieee.std_logic_1164.all;

entity adc_fsm is
	generic 
	(
		ADDR_WIDTH : natural := 6
	);
	
	port (
		adc_clk: in  	std_logic;
		reset:	in		std_logic;
		tail:		in		natural range 0 to 2**ADDR_WIDTH - 1;
		eoc:		in		std_logic;
		store:	out	std_logic;
		start:	out 	std_logic;
		head:		out	natural range 0 to 2**ADDR_WIDTH - 1
	);
end entity adc_fsm;


architecture adc_to_ram of adc_fsm is
	-- Put signals here.
	type state_type is (start_adc, wait_data, check_space, write_data);
	signal state, next_state : state_type := start_adc;
	
	function snake_cond(
			h, t: in natural range 0 to 2**ADDR_WIDTH - 1
		) return boolean
	is
	begin
	   -- If true, go to write_data
      -- If false, go to check_space
		if (t > h and t - h > 2) or (h > t and h - t > 2**ADDR_WIDTH - 1) then
			return true;
		else
			return false;
		end if;
	end function snake_cond;
	
	signal internal_head: natural range 0 to 2**ADDR_WIDTH - 1;
	
begin
	head <= internal_head;
	-- store state
	store_state: process(adc_clk, reset) is
	begin
		if reset = '0' then
			state <= start_adc;
		elsif rising_edge(adc_clk) then
			state <= next_state;
		end if;
	end process store_state;
	-- start adc
	start <= '1' when state = start_adc else '0';
	
	-- waiting for data (loop)
	set_state: process(state, internal_head, tail, eoc) is
	begin
		case state is
			when start_adc => next_state <= wait_data;
			when wait_data =>
				if eoc = '0' then
					next_state <= wait_data;
				else
					next_state <= check_space;
				end if;
			when check_space =>
				if snake_cond(internal_head, tail) then
					next_state <= write_data;
				else
					next_state <= check_space;
				end if;
			when write_data => next_state <= start_adc;
		end case;
	end process set_state;
	
	-- store, start, internal_head
	
	-- TODO: Check if outputs are correct for each state
	output_state: process(state, internal_head, tail, eoc) is
	begin
		case state is
			when start_adc => 	
				store <= '0';
				start <= '1';
				-- Increment internal_head pointer for new address
				internal_head <= internal_head;
			when wait_data => 	
				store <= '0';
				start <= '0';
			when check_space =>
				store <= '0';
				start <= '0';
			when write_data =>
				store <= '1';
				start <= '0';
				-- Increment internal_head pointer for new address
				internal_head <= internal_head + 1;
				
		end case;
	end process output_state;
			
	-- move internal_head and write

end architecture adc_to_ram;
