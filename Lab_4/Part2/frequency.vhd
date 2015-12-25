library ieee;
 use ieee.std_logic_1164.all;
 use ieee.std_logic_unsigned.all;

entity frequency is
 port(clk50M:in std_logic;
      clk_1hz:out std_logic);
 end entity frequency;

architecture behave of frequency is
 signal t:std_logic_vector(24 downto 0);
 signal clk:std_logic;
 begin
  process(clk50M)
  begin 
  if rising_edge(clk50M) then
     if t="1011111010111100000111111" then
       t<="0000000000000000000000000";
     clk<=not clk;
     else t<=t+1;
     end if;
  end if;
  end process;
  clk_1hz<=clk;
  end architecture behave;
