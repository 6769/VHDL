library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; -- for overloaded + operator and conversion functions

entity clk_divider is
  port(Sysclk, rst_b: in std_logic;
       Sel: in unsigned(2 downto 0);
       BclkX8: buffer std_logic;
       Bclk: out std_logic);
end clk_divider;

architecture baudgen of clk_divider is
  signal ctr1: unsigned(3 downto 0) := "0000";   -- divide by 13 counter
  signal ctr2: unsigned(7 downto 0) := "00000000";   -- div by 256 ctr
  signal ctr3: unsigned(2 downto 0) := "000";   -- divide by 8 counter
  signal Clkdiv13: std_logic;
begin
  process(Sysclk)   -- first divide system clock by 13
  begin
    if (Sysclk'event and Sysclk = '1') then
      if (ctr1 = "1100") then ctr1 <= "0000";
      else ctr1 <= ctr1 + 1;
      end if;
    end if;
  end process;
  Clkdiv13 <= ctr1(3);   -- divide Sysclk by 13
  
  process(Clkdiv13)   -- ctr2 is an 8-bit counter
  begin
    if (Clkdiv13'event and Clkdiv13 = '1') then
      ctr2 <= ctr2 + 1;
    end if;
  end process;
  
  BclkX8 <= ctr2(to_integer(sel));   -- select baud rate
  process(BclkX8)
  begin
    if (BclkX8'event and BclkX8 = '1') then
      ctr3 <= ctr3 + 1;
    end if;
  end process;
  Bclk <= ctr3(2);   -- Bclk is BclkX8 divided by 8
end baudgen;
