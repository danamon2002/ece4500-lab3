library ieee;
use ieee.std_logic_1164.all;

package seven_segment_pkg is

	type seven_segment_config is
	record
		a: std_logic;
		b: std_logic;
		c: std_logic;
		d: std_logic;
		e: std_logic;
		f: std_logic;
		g: std_logic;
	end record;
	
	type seven_segment_array is array(natural range<>) of seven_segment_config;
	
	type lamp_configuration is (common_anode, common_cathode);
	
	constant default_lamp_config : lamp_configuration := common_anode;

	constant seven_segment_table : seven_segment_array := (
		0 => (a => '0', b => '0', c => '0', d => '0', e => '0', f => '0', g => '1'),
		1 => (a => '1', b => '0', c => '0', d => '1', e => '1', f => '1', g => '1'),
		2 => (a => '0', b => '0', c => '1', d => '0', e => '0', f => '1', g => '0'),
		3 => (a => '0', b => '0', c => '0', d => '0', e => '1', f => '1', g => '0'),
		4 => (a => '1', b => '0', c => '0', d => '1', e => '1', f => '0', g => '0'),
		5 => (a => '0', b => '1', c => '0', d => '0', e => '1', f => '0', g => '0'),
		6 => (a => '0', b => '1', c => '0', d => '0', e => '0', f => '0', g => '0'),
		7 => (a => '0', b => '0', c => '0', d => '1', e => '1', f => '1', g => '1'),
		8 => (a => '0', b => '0', c => '0', d => '0', e => '0', f => '0', g => '0'),
		9 => (a => '0', b => '0', c => '0', d => '0', e => '1', f => '0', g => '0'),
		10 => (a => '0', b => '0', c => '0', d => '1', e => '0', f => '0', g => '0'),
		11 => (a => '1', b => '1', c => '0', d => '0', e => '0', f => '0', g => '0'),
		12 => (a => '0', b => '1', c => '1', d => '0', e => '0', f => '0', g => '1'),
		13 => (a => '1', b => '0', c => '0', d => '0', e => '0', f => '1', g => '0'),
		14 => (a => '0', b => '1', c => '1', d => '0', e => '0', f => '0', g => '0'),
		15 => (a => '0', b => '1', c => '1', d => '1', e => '0', f => '0', g => '0')
	);

	subtype hex_digit is natural range seven_segment_table'range;

	function get_hex_digit (
		digit:		in hex_digit;
		lamp_mode: 	in lamp_configuration := default_lamp_config
	) return seven_segment_config;

	function lamps_off (
		lamp_mode:  in lamp_configuration := default_lamp_config
	) return seven_segment_config;

end package seven_segment_pkg;



package body seven_segment_pkg is

	function "not" (
			digit: in seven_segment_config
		) return seven_segment_config
	
	is
	begin
		return (
			a => not digit.a,
			b => not digit.b,
			c => not digit.c,
			d => not digit.d,
			e => not digit.e,
			f => not digit.f,
			g => not digit.g
		);
	end function "not";

	function get_hex_digit (
		digit:		in hex_digit;
		lamp_mode: 	in lamp_configuration := default_lamp_config
	) return seven_segment_config
	is
	begin
		if lamp_mode = common_cathode then
			return not seven_segment_table(digit);
		end if;
		return seven_segment_table(digit);
	end function get_hex_digit;
	
	function lamps_off (
		lamp_mode: in lamp_configuration := default_lamp_config
	) return seven_segment_config
	is
	begin
		if lamp_mode = common_anode then
			return (a => '1', b => '1', c => '1', d => '1', e => '1', f => '1', g => '1');
		else
			return (a => '0', b => '0', c => '0', d => '0', e => '0', f => '0', g => '0');
		end if;
	end function lamps_off;

end package body seven_segment_pkg;
