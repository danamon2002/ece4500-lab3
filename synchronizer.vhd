library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity synchronizer is
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
end entity synchronizer;

architecture sync of synchronizer is
	
	component gray_to_bin is
		generic (
			input_width:	positive := 16
		);
		port (
			gray_in:		in	std_logic_vector(input_width - 1 downto 0);
			bin_out:		out	std_logic_vector(input_width - 1 downto 0)
		);
	end component;
	
	component bin_to_gray is
		generic (
			input_width:	positive :=	16
		);
		port (
			bin_in:			in	std_logic_vector(input_width - 1 downto 0);
			gray_out:		out	std_logic_vector(input_width - 1 downto 0)
		);
	end component;
	
	signal bin_out 	: std_logic_vector(input_width - 1 downto 0);
	signal dff_in, dff_out1, dff_out2, dff_out3 : std_logic_vector(input_width - 1 downto 0);
	signal bin_in_vector : std_logic_vector(input_width - 1 downto 0);
	--std_logic_vector(to_unsigned(addr_in, input_width));
	
begin
	
	bin_in_vector <= std_logic_vector(to_unsigned(addr_in, input_width));
	
	b2g: bin_to_gray 
		port map(
			-- Convert natural address to std_logic_vector
			bin_in 		=> bin_in_vector,
			gray_out 	=> dff_in
		);
	
	
	-- The three processes below are the three flip-flops of our synchronizer.
	ff_1 : process(clk_in) is
	begin
		if rising_edge(clk_in) then
			dff_out1 <= dff_in;
		end if;
	end process ff_1;
	
	ff_2 : process(clk_in) is
	begin
		if rising_edge(clk_in) then
			dff_out2 <= dff_out1;
		end if;
	end process ff_2;
	
	ff_3 : process(clk_in) is
	begin
		if rising_edge(clk_in) then
			dff_out3 <= dff_out2;
		end if;
	end process ff_3;
	
	
	g2b: gray_to_bin
		port map(
			gray_in	=> dff_out3,
			bin_out	=> bin_out
		);
	
	-- Convert std_logic_vector to unsigned integer address
	addr_out <= to_integer(unsigned(bin_out));
	
end architecture;
	
