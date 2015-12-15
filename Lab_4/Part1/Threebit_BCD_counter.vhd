library ieee;
use ieee.numeric_bit.all;

entity Threebit_BCD_counter is
	port( clk:in bit;reset:in bit;
	Counter_Result:out unsigned(11 downto 0) );
end entity Threebit_BCD_counter;

architecture combination of Threebit_BCD_counter is

signal midcarry:bit_vector(2 downto 1);
signal mid_second:bit;

alias hex0:unsigned(3 downto 0) is Counter_Result(3 downto 0);
alias hex1:unsigned(3 downto 0) is Counter_Result(7 downto 4);
alias hex2:unsigned(3 downto 0) is Counter_Result(11 downto 8);
component counter_max10
	port(clk:in bit ;reset:in bit;limit:in bit;
		carry:out bit;
		CountedNumber:buffer unsigned(3 downto 0));
end component;

component clock_second is
	port(clk:in bit ;
		second:buffer bit);
end component;

begin
	High50MhzToSecond:clock_second port map(clk,mid_second);
	hex0_lable:counter_max10 port map(mid_second,reset,'1',midcarry(1),hex0);
    hex1_lable:counter_max10 port map(mid_second,reset,midcarry(1),midcarry(2),hex1 );
    hex2_lable:counter_max10 port map(mid_second,reset,midcarry(2),open ,hex2 );


end architecture combination;