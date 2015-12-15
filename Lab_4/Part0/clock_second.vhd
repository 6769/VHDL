--Intertime clock
library ieee;
use ieee.numeric_bit.all;

entity clock_second is
	port(clk:in bit ;
		second:buffer bit);
end entity clock_second;

architecture Distribution of clock_second is

signal counter_for_osc_signal:unsigned(31 downto 0);
begin
	process
   
	begin

		wait until clk'event and clk='1';
		if counter_for_osc_signal < 50*1000*1000 
			then 
			counter_for_osc_signal<=counter_for_osc_signal+1;
			else counter_for_osc_signal<=(others=>'0');
		end if;
	end process;
	second<='1' when counter_for_osc_signal> 25*1000*1000 --High_percent_of_counter
		else '0' ;
end architecture Distribution;

