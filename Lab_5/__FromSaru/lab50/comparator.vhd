library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity comparator is
  port(point:in std_logic_vector(3 downto 0);
       sum:in std_logic_vector(3 downto 0);
       eq:out bit);
end comparator;

architecture compare of comparator is
begin
--could be alternatived by MUX statements...3 lines...--
  process(point,sum)
  begin
    if point=sum then
      eq<='1';
    else eq<='0';
    end if;
  end process;
end compare;