library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity counter_1_6 is
  port(clk_50m,roll:in bit;
       out_count:inout std_logic_vector(3 downto 0));
end counter_1_6;

architecture count of counter_1_6 is

signal count:std_logic_vector(3 downto 0):="0000";

begin
  process(clk_50m,roll,count)
  begin
  if roll='1' then
    if clk_50m'event and clk_50m='0' then
      if count>"0100" then
        count<="0001";
		else count<=count+1;
      end if;
    end if;
  else out_count<=count;
  end if;
  end process;
end count;