library ieee;
use ieee.numeric_bit.all;

entity View is
	port(Clk_original,Reset,Ldn:in bit;
		Din:in unsigned(15 downto 0);
		hex0,hex1,hex2,hex3,hex4,hex5:out unsigned(7 downto 0));
end entity View;

architecture Behave of View is

component clock_signal_per_second is
    port(clk:in bit;
	second_output:buffer bit);
end component;
component Segment7Decoder is
	port (bcd	: in unsigned(3 downto 0);  --BCD input
        segment7 : out unsigned(6 downto 0)  -- 7 bit decoded output.
    );
end component;
component H24_Min60_Sec60_v2 is
    port(Clk,Ldn,Reset:in bit;
        Din :in  unsigned(15 downto 0);
        Qout:out unsigned(23 downto 0));
end component;
signal mid_second:bit;
signal Q:unsigned(23 downto 0);
	alias Second_low:unsigned(3 downto 0) is Q(3 downto 0);
    alias Second_hig:unsigned(3 downto 0) is Q(7 downto 4);
    alias Min_low:   unsigned(3 downto 0) is Q(11 downto 8);
    alias Min_hig:   unsigned(3 downto 0) is Q(15 downto 12);
    alias Hour_low:  unsigned(3 downto 0) is Q(19 downto 16);
    alias Hour_hig:  unsigned(3 downto 0) is Q(23 downto 20);
begin
	hex0(0)<='1';
	hex1(0)<='1';
	hex2(0)<='1';
	hex3(0)<='1';
	hex4(0)<='1';
	hex5(0)<='1';
	High50Mhz:clock_signal_per_second port map(Clk_original,mid_second);
	Core:H24_Min60_Sec60_v2 port map(mid_second,Ldn,Reset,Din,Q);
	Hex0_display:Segment7Decoder port map(Second_low,hex0(7 downto 1));
	Hex1_display:Segment7Decoder port map(Second_hig,hex1(7 downto 1));
	Hex2_display:Segment7Decoder port map(Min_low,  hex2(7 downto 1));
	Hex3_display:Segment7Decoder port map(Min_hig,hex3(7 downto 1));
	Hex4_display:Segment7Decoder port map(Hour_low,hex4(7 downto 1));
	Hex5_display:Segment7Decoder port map(Hour_hig,hex5(7 downto 1));
end architecture Behave;

