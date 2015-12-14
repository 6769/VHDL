library ieee;
use ieee.numeric_bit.all;
entity clock_second is
	port(clk :in bit;
		second:out bit);
		--Qout:out unsigned(31 downto 0));
end entity clock_second;

architecture neibu of clock_second is
	signal Q:unsigned(5 downto 0);
	--signal Nullth:unsigned(31 downto 0);
begin
	--Qout<=Q;
	second<='0' when Q>25 
		else '1';
	process(clk)
	begin
		if clk'event and clk='1' and Q<50 then
			Q<=Q+1;
		elsif clk'event and clk='1' then
			Q<=(others=>'0');
		end if;
	end process;

end architecture neibu;