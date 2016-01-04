library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity test_logic is
  port(sum:in std_logic_vector(3 downto 0);
       d7,d711,d2312:out bit);
end test_logic;

architecture test of test_logic is
begin
  process(sum)
  begin
    if sum="0111" then
      d7<='1';
    else d7<='0';
    end if;
    if sum="0111" or sum="1011" then
      d711<='1';
    else d711<='0';
    end if;
    if sum="0010" or sum="0011" or sum="1100" then
      d2312<='1';
    else d2312<='0';
    end if;
  end process;
end test;