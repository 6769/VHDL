library IEEE;
use IEEE.numeric_bit.all;

entity LUTmult is
  port(Mplier, Mcand: in unsigned(3 downto 0);
       Product: out unsigned(7 downto 0));
end LUTmult;

architecture ROM1 of LUTmult is
type ROM is array (0 to 255) of unsigned(7 downto 0);
constant PROD_ROM: ROM :=
  (x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00",
	 x"00", x"01", x"02", x"03", x"04", x"05", x"06", x"07", x"08", x"09", x"0A", x"0B", x"0C", x"0D", x"0E", x"0F",
	 x"00", x"02", x"04", x"06", x"08", x"0A", x"0C", x"0E", x"10", x"12", x"14", x"16", x"18", x"1A", x"1C", x"1E",
	 x"00", x"03", x"06", x"09", x"0C", x"0F", x"12", x"15", x"18", x"1B", x"1E", x"21", x"24", x"27", x"2A", x"2D",
	 x"00", x"04", x"08", x"0C", x"10", x"14", x"18", x"1C", x"20", x"24", x"28", x"2C", x"30", x"34", x"38", x"3C",
	 x"00", x"05", x"0A", x"0F", x"14", x"19", x"1E", x"23", x"28", x"2D", x"32", x"37", x"3C", x"41", x"46", x"4B",
	 x"00", x"06", x"0C", x"12", x"18", x"1E", x"24", x"2A", x"30", x"36", x"3C", x"42", x"48", x"4E", x"54", x"5A",
	 x"00", x"07", x"0E", x"15", x"1C", x"23", x"2A", x"31", x"38", x"3F", x"46", x"4D", x"54", x"5B", x"62", x"69",
	 x"00", x"08", x"10", x"18", x"20", x"28", x"30", x"38", x"40", x"48", x"50", x"58", x"60", x"68", x"70", x"78",
	 x"00", x"09", x"12", x"1B", x"24", x"2D", x"36", x"3F", x"48", x"51", x"5A", x"63", x"6C", x"75", x"7E", x"87",
	 x"00", x"0A", x"14", x"1E", x"28", x"32", x"3C", x"46", x"50", x"5A", x"64", x"6E", x"78", x"82", x"8C", x"96",
	 x"00", x"0B", x"16", x"21", x"2C", x"37", x"42", x"4D", x"58", x"63", x"6E", x"79", x"84", x"8F", x"9A", x"A5",
	 x"00", x"0C", x"18", x"24", x"30", x"3C", x"48", x"54", x"60", x"6C", x"78", x"84", x"90", x"9C", x"A8", x"B4",
	 x"00", x"0D", x"1A", x"27", x"34", x"41", x"4E", x"5B", x"68", x"75", x"82", x"8F", x"9C", x"A9", x"B6", x"C3",
	 x"00", x"0E", x"1C", x"2A", x"38", x"46", x"54", x"62", x"70", x"7E", x"8C", x"9A", x"A8", x"B6", x"C4", x"D2",
	 x"00", x"0F", x"1E", x"2D", x"3C", x"4B", x"5A", x"69", x"78", x"87", x"96", x"A5", x"B4", x"C3", x"D2", x"E1");

begin
  Product <= PROD_ROM(to_integer(Mplier&Mcand));  -- read Product LUT
end ROM1;
