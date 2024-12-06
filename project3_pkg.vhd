library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package project3_pkg is

	component PLL is
		PORT(
				inclk0		: IN STD_LOGIC  := '0';
				c0		: OUT STD_LOGIC 
			);
	end component PLL;
	
	component max10_adc is
		port (
			pll_clk:	in	std_logic;
			chsel:	in	natural range 0 to 2**5 - 1;
			soc:		in	std_logic;
			tsen:		in	std_logic;
			dout:		out	natural range 0 to 2**12 - 1; 
			eoc:		out	std_logic; 
			clk_dft:	out	std_logic
		);
	end component max10_adc;
	
	component adc_fsm is
		generic (
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
	end component adc_fsm;

	component dual_port_ram is
		generic 
		(
			DATA_WIDTH : natural := 12;
			ADDR_WIDTH : natural := 6
		);

		port 
		(
			clk_a	: in std_logic;
			clk_b	: in std_logic;
			addr_a	: in natural range 0 to 2**ADDR_WIDTH - 1;
			addr_b	: in natural range 0 to 2**ADDR_WIDTH - 1;
			data_a	: in std_logic_vector((DATA_WIDTH-1) downto 0);
			data_b	: in std_logic_vector((DATA_WIDTH-1) downto 0);
			we_a	: in std_logic := '1';
			we_b	: in std_logic := '1';
			q_a		: out std_logic_vector((DATA_WIDTH -1) downto 0);
			q_b		: out std_logic_vector((DATA_WIDTH -1) downto 0)
		);
	end component dual_port_ram;
	
	component seven_segment_fsm is
		generic 
		(
			ADDR_WIDTH : natural := 6
		);
		port (
			reset:	in 	std_logic;
			seg_clk: in  	std_logic;
			tail:		out	natural range 0 to 2**ADDR_WIDTH - 1;
			head:		in		natural range 0 to 2**ADDR_WIDTH - 1
		);
	end component seven_segment_fsm;
	
	
	component synchronizer is 
		generic 
		(
			ADDR_WIDTH : natural := 6;
			input_width : positive := 16 
		);
		port (
			clk_in	: in std_logic; -- Input clock
			clk_out : in std_logic; -- Output clock
			-- Head or Tail
			addr_in	: in natural range 0 to 2**ADDR_WIDTH - 1; 
			addr_out: out natural range 0 to 2**ADDR_WIDTH - 1
		);
	end component synchronizer;

	function to_bcd (
		data_value:		in std_logic_vector(15 downto 0)
	) return std_logic_vector;
	
end project3_pkg;

package body project3_pkg is

	-- Type Declaration (optional)

	-- Subtype Declaration (optional)

	-- Constant Declaration (optional)

	-- Function Declaration (optional)

	-- Function Body (optional)

	-- Procedure Declaration (optional)

	-- Procedure Body (optional)

	function to_bcd (
		 data_value: in std_logic_vector(15 downto 0)
	) return std_logic_vector is
		 variable ret: std_logic_vector(19 downto 0);
		 variable temp: std_logic_vector(data_value'range);
	begin
		 -- Initialize temporary variables
		 temp := data_value;
		 ret := (others => '0');
		 
		 -- Loop through all the bits of the data_value
		 for i in data_value'range loop
			  -- Apply BCD conversion logic
			  for j in 0 to ret'length/4 - 1 loop
					-- Check and adjust BCD values if necessary
					if unsigned(ret(4*j + 3 downto 4*j)) >= 5 then
						 ret(4*j + 3 downto 4*j) := std_logic_vector(
							  unsigned(ret(4*j + 3 downto 4*j)) + 3
						 );
					end if;
			  end loop;

			  -- Shift and update ret and temp for next iteration
			  ret := ret(ret'high - 1 downto 0) & temp(temp'high);
			  temp := temp(temp'high - 1 downto 0) & '0';
		 end loop;
		 
		 -- Return the BCD result
		 return ret;
	end function to_bcd;

	
--	function to_bcd (
--			data_value: in std_logic_vector(15 downto 0)
--		) return std_logic_vector
--	is
--		variable ret: std_logic_vector(19 downto 0);
--		variable temp: std_logic_vector(data_value'range);
--	begin
--		temp := data_value;
--		ret := (others => '0');
--		for i in data_value'range loop
--			for j in 0 to ret'length/4 - 1 loop
--				if unsigned(ret(4*j + 3 downto 4*j)) >= 5 then
--					ret(4*j + 3 downto 4*j) :=
--						std_logic_vector(
--							unsigned(ret(4*j + 3 downto 4 * j)) + 3);
--				end if;
--			end loop;
--			ret := ret(ret'high -1 downto 0) & temp(temp'high);
--			temp := temp(temp'high - 1 downto 0) & '0';
--		end loop;
--		return ret;
--	end function to_bcd;

end project3_pkg;


