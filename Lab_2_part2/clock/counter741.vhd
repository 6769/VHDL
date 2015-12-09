--741
library ieee;
use ieee.numeric_bit.all;
entity counter741 is
	port(clk :in bit;
		second:out bit;
		Qout:out unsigned(31 downto 0));
end entity counter741;

architecture neibu of counter741 is
	signal Q:unsigned(31 downto 0);
	signal Nullth:unsigned(31 downto 0);
begin
	Qout<=Q;
	second<='0' when Q>25 
		else '1';
	process(clk)
	begin
		if clk'event and clk='1' and Q<50 then
			Q<=Q+1;
		elsif clk'event and clk='1' then
			Q<=Nullth;
		end if;
	end process;

end architecture neibu;