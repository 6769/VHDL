-- Simple memory model
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity RAM6116 is
  port(Cs_b, We_b, Oe_b: in std_logic;
       Address: in unsigned(7 downto 0);
       IO: inout unsigned(7 downto 0));
end RAM6116;

architecture simple_ram of RAM6116 is
type RAMtype is array(0 to 255) of unsigned(7 downto 0);
signal RAM1: RAMtype:=(others=>(others=>'0'));
                       -- Initialize all bits to '0'
begin
  IO <= "ZZZZZZZZ" when Cs_b = '1' or We_b = '0' or Oe_b = '1'
    else RAM1(to_integer(Address));   -- read from RAM
  process(We_b, Cs_b)
  begin
    if Cs_b = '0' and rising_edge(We_b) then   -- rising-edge of We
      RAM1(to_integer(Address'delayed)) <= IO; -- write
    end if;
  end process;
end simple_ram;
