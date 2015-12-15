library ieee;
use ieee.numeric_bit.all;

entity counter_max10 is
	port(clk:in bit ;reset:in bit;limit:in bit;
		carry:out bit;
		CountedNumber:buffer unsigned(3 downto 0));
end entity counter_max10;

architecture behavior of counter_max10 is

begin
	carry<=CountedNumber(3)and CountedNumber(0)and limit;--"1001" 
	process(clk,reset,limit)
	begin
		if(reset='0') then CountedNumber<=(others=>'0');
		elsif (clk'event and clk='1' and limit='1') then 
			if(CountedNumber< 9) then	CountedNumber<=CountedNumber+1;
			else CountedNumber<="0000";
			end if;
		end if;
	end process;
end architecture behavior;