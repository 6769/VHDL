library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity adder is
  port(addend1,addend2:in std_logic_vector(3 downto 0);
  sum:out std_logic_vector(3 downto 0));
end adder;

architecture add of adder is
begin
  sum<=addend1+addend2;
end add;