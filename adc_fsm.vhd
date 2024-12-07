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
	
	attribute syn_encoding: string;
	attribute keep: boolean;
	--attribute keep of state: signal is true;
	--attribute syn_encoding of state_type: type is "sequential";
	
	constant top_address: positive := 2**ADDR_WIDTH - 1;
	
	function snake_cond(
    h, t: in natural range 0 to 2**ADDR_WIDTH - 1
	) return boolean
	is
	begin
		 -- If true, go to write_data
		 -- If false, go to check_space
		 -- If Head has reached max buffer size, set head to 0
		if t > h and t - h > 1 then
			return true;
		elsif h > t and not ( h = top_address and t = 1 ) then
			return true;
		elsif h > t and not ( h = top_address - 1 and t = 0) then
			return true;
		end if;
		 
		return false;
	 
	end function snake_cond;
	
	signal internal_head: natural range 0 to 2**ADDR_WIDTH - 1;
	
begin
	--head <= internal_head;
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
	-- start <= '1' when state = start_adc else '0';
	
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
	output_state: process(adc_clk, reset) is
	begin
		if reset = '0' then
			store <= '0';
			start <= '0';
			internal_head <= 0;
		elsif rising_edge(adc_clk) then
			store <= '0';
			start <= '0';
			if state = start_adc then
				start <= '1';
			end if;
			
			if state = write_data then
				store <= '1';
				if internal_head = top_address then
					internal_head <= 0;
				else
					internal_head <= internal_head + 1;
				end if;
			end if;
			
--			case state is
--				when start_adc => 	
--					store <= '0';
--					start <= '1';
--				when wait_data => 	
--					store <= '0';
--					start <= '0';
--				when check_space =>
--					store <= '0';
--					start <= '0';
--				when write_data =>
--					store <= '1';
--					start <= '0';
--					-- output internal head pointer to rest of circuit 
--					--head <= internal_head;
--					if internal_head = 2**ADDR_WIDTH - 1 then
--						internal_head <= 0;
--					else
--						internal_head <= internal_head + 1;
--					end if; 	
--			end case;
		end if;
	end process output_state;
	
	head <= internal_head;
	-- move internal_head and write

end architecture adc_to_ram;
