library ieee;
use ieee.std_logic_1164.all;
entity dec3to8 is
	port (
		W : in STD_LOGIC_VECTOR(2 downto 0);
		En : in STD_LOGIC;
		Y : out STD_LOGIC_VECTOR(0 to 7)
	);
end dec3to8;

architecture Behavior of dec3to8 is
begin
	process (W, En)
	begin
		if En = '1' then
			case W is
				when "000" => Y <= "10000000";
				when "001" => Y <= "01000000";
				when "010" => Y <= "00100000";
				when "011" => Y <= "00010000";
				when "100" => Y <= "00001000";
				when "101" => Y <= "00000100";
				when "110" => Y <= "00000010";
				when "111" => Y <= "00000001";
                when others=> null;
			end case;
		else
			Y <= "00000000";
		end if;
	end process;
end Behavior;