
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
entity upcount is
	port (
		Clear, Clock : in STD_LOGIC;
		Q : out STD_LOGIC_VECTOR(1 downto 0)
	);
end upcount;

architecture Behavior of upcount is
	signal Count : STD_LOGIC_VECTOR(1 downto 0);
begin
	process (Clock)
	begin
		if (Clock'EVENT and Clock = '1') then
			if Clear = '1' then
				Count <= "00";
			else
				Count <= Count + 1;
			end if;
		end if;
	end process;
	Q <= Count;
end Behavior;