library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.project3_pkg.all;
use work.seven_segment_pkg.all;

entity toplevel is
	generic (
			ADDR_WIDTH : natural := 6;
			DATA_WIDTH : natural := 12
		);
	port( -- Input 
			adc_clock	:	in std_logic; -- 10 MHz clock
			main_clock	: 	in std_logic; -- 50 MHz clock 
			reset			:	in std_logic;
			-- Output
			-- Six Displays on DE-10 FPGA
			seven_segment : out seven_segment_array(0 to 5)
		);
end entity toplevel;


architecture top of toplevel is

	-- TODO: CREATE SIGNALS FOR COMPONENTS
	signal PLL_CLK, ADC_CLK : std_logic;
	signal eoc, start, store : std_logic;
	-- Output from Synchronizers
	signal head_out, tail_out : natural range 0 to 2**ADDR_WIDTH - 1;
	-- Output from FSMs
	signal head, tail : natural range 0 to 2**ADDR_WIDTH - 1;
	-- ADC Output
	signal adc_out : natural range 0 to 2**ADDR_WIDTH - 1;
	-- RAM Port B Output (SEVEN SEGMENT)
	signal data_out : std_logic_vector(DATA_WIDTH - 1 downto 0);

	
	signal counter: std_logic_vector(36 downto 0);
	signal bcd : std_logic_vector(23 downto 0);
	
	--type out_arr_type is array range (0 to 6) of natural range 0 to 2**ADDR_WIDTH - 1;
	
	signal temp : natural range 0 to 2**ADDR_WIDTH - 1;
	signal temp2 : natural range 0 to 2**ADDR_WIDTH - 1;
	
begin

--	do_count: process(main_clock, reset) is
--	begin
--		if reset = '0' then
--			counter <= (others => '0');
--		elsif rising_edge(main_clock) then
--			counter <= std_logic_vector(unsigned(counter) + 1);
--		end if;
--	end process do_count;

	set_outs: for i in 0 to 5 generate
		seven_segment(i) <= get_hex_digit(to_integer(unsigned(bcd(4*i + 3 downto 4*i))));
		--seven_segment(i) <= get_hex_digit(to_integer(unsigned(bcd)) rem (10**(i + 1)) / 10**i);	
	end generate set_outs;
	
		bcd <= "0000" & to_bcd("1111" & data_out);
	
	-- PLL 
	pll_module: pll
		port map (
			inclk0 => adc_clock,
			c0 => PLL_CLK
		);
	
	-- ADC
	adc_module: max10_adc 
		port map (
				pll_clk 	=> PLL_CLK,
				-- Channel Select
				chsel => 0,
				-- Start of Conversion
				soc 	=> start,
				-- Temperature select (1 = temperature, 0 = normal)
				tsen 	=> '1',
				-- Data Output
				dout 	=> adc_out,
				-- End of Conversion
				eoc 	=> eoc,
				-- Clock Output from Clock Divider
				clk_dft 	=> ADC_CLK
		); 
	
	-- ADC_FSM
	adc_fsm_module: adc_fsm 
		generic map (
			ADDR_WIDTH => ADDR_WIDTH
		)
		port map (
			adc_clk 	=> ADC_CLK,
			reset 	=> '1',
			tail		=> tail_out,
			eoc		=> eoc,
			store		=> store,
			start		=> start,
			head		=> head
		);
	
	-- Dual Port Ram
	RAM: dual_port_ram
		generic map (
			DATA_WIDTH => DATA_WIDTH,
			ADDR_WIDTH => ADDR_WIDTH
		)
		port map (
			-- ADC 
			clk_a	=> ADC_CLK,
			addr_a	=> head,
			data_a 	=> std_logic_vector(to_unsigned(adc_out, DATA_WIDTH)),
			we_a 	=> store, 
			q_a	=> open,
			-- SEVEN_SEGMENT
			clk_b => main_clock, -- 50 MHz clock
			addr_b	=> tail,
			data_b	=> (others => '0'),
			we_b 	=> '0',
			q_b 	=> data_out
		);
	
	-- Synchronizers
	
	-- SEVEN_SEGMENT to ADC
	SS_to_ADC: synchronizer
		generic map (
			ADDR_WIDTH 	=> ADDR_WIDTH
		)
		port map (
			-- Inputs
			clk_in	=> main_clock, 	-- SEVEN_SEGMENT CLOCK
			clk_out 	=> ADC_CLK, -- ADC CLOCK
			addr_in	=> tail,	 	-- TAIL FROM SEVEN_SEGMENT_FSM
			-- Output
			addr_out	=> tail_out -- TAIL TO ADC_FSM
		);
	
	-- ADC TO SEVEN_SEGMENT
	ADC_to_SS: synchronizer
		generic map (
			ADDR_WIDTH 	=> ADDR_WIDTH
		)
		port map (
			-- Inputs
			clk_in	=> ADC_CLK, -- ADC CLOCK
			clk_out 	=> main_clock, 	-- SEVEN_SEGMENT CLOCK
			addr_in	=> head, 	-- HEAD FROM ADC_FSM
			-- Output
			addr_out	=>	head_out -- HEAD TO SEVEN_SEGMENT
		);
	
	-- SEVEN_SEGMENT_FSM
	SS_FSM: seven_segment_fsm
		generic map (
			ADDR_WIDTH => ADDR_WIDTH
		)
		port map (
			reset 	=> '0',
			seg_clk	=> main_clock, 	-- 50 MHz clock
			head	=> head_out, 	-- FROM SYNCHRONIZER
			tail	=> tail
		);	
		

end architecture top;