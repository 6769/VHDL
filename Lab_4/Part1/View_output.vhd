library ieee;
use ieee.numeric_bit.all;

entity View_output is
	port(clk:in bit; reset:in bit;
	hex0_out:out bit_vector(7 downto 0);
	hex1_out:out bit_vector(7 downto 0);
	hex2_out:out bit_vector(7 downto 0));
end entity View_output;

architecture combination_of_View of View_output is
--type 
component Threebit_BCD_counter is
	port( clk:in bit;reset:in bit;
	Counter_Result:out unsigned(11 downto 0) );
end component;
component Segment7Decoder is
	port (bcd	: in bit_vector(3 downto 0);  --BCD input
        segment7 : out bit_vector(7 downto 1)  -- 7 bit decoded output.
    );
end component;
signal mid_12bit_result:unsigned(11 downto 0);
alias mid_hex0:unsigned(3 downto 0) is mid_12bit_result(3 downto 0);
alias mid_hex1:unsigned(3 downto 0) is mid_12bit_result(7 downto 4);
alias mid_hex2:unsigned(3 downto 0) is mid_12bit_result(11 downto 8);
begin
	Synthesis:Threebit_BCD_counter port map(clk,reset,mid_12bit_result);
	hex0_out(0)<='1';
	hex1_out(0)<='1';
	hex2_out(0)<='1';
	hex0_display:Segment7Decoder port map(bit_vector(mid_hex0),hex0_out(7 downto 1));
	hex1_display:Segment7Decoder port map(bit_vector(mid_hex1),hex1_out(7 downto 1));
	hex2_display:Segment7Decoder port map(bit_vector(mid_hex2),hex2_out(7 downto 1));
end architecture combination_of_View;