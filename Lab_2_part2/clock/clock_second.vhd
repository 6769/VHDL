--Intertime clock
library ieee;
use ieee.numeric_bit.all;

entity clock_second is
	port(clk50Mhz:in bit ;
		second:buffer bit);
end entity clock_second;

architecture Distribution of clock_second is

signal counter_for_osc_signal,nothing:unsigned(31 downto 0);
begin
	process
	begin
--		if clk50Mhz'event and clk50Mhz='1' then
		
--			if counter_for_osc_signal < 50*1000 and counter_for_osc_signal>25*1000 then
--				second<='1';
--				--counter_for_osc:=counter_for_osc+1;
--				counter_for_osc_signal<=counter_for_osc_signal+1;
--			elsif counter_for_osc_signal>25*1000 then 
--				second<='0';
--				--counter_for_osc:=counter_for_osc+1;
--				counter_for_osc_signal<=counter_for_osc_signal+1;
--			elsif counter_for_osc_signal=50*1000 then
--				--counter_for_osc:=0;
--				counter_for_osc_signal<=0;
--			end if;
--		end if;
		wait until clk50Mhz'event and clk50Mhz='1';
		if counter_for_osc_signal < 50*1000*1000 then 
			counter_for_osc_signal<=counter_for_osc_signal+1;
			else counter_for_osc_signal<=nothing;
		end if;
	end process;
	second<='1' when counter_for_osc_signal>25*1000*1000
		else '0' ;
end architecture Distribution;

