library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity RAM_timing_tester is
end RAM_timing_tester;

architecture test1 of RAM_timing_tester is
  component static_RAM is
    port(CS_b, WE_b, OE_b: in std_logic;
         Address: in unsigned(7 downto 0);
         IO: inout unsigned(7 downto 0));
  end component Static_RAM;
  signal Cs_b, We_b: std_logic := '1';  -- active low signals
  signal Data: unsigned(7 downto 0) := "ZZZZZZZZ";
  signal Address: unsigned(7 downto 0):= "00000000";
begin
  SRAM1: Static_RAM port map(Cs_b, We_b, '0', Address, Data);
  process
  begin
    wait for 20 ns;
    Address <= "00001000";              -- WE-controlled write
    Cs_b <= transport '0', '1' after 50 ns;
    We_b <= transport '0' after 8 ns, '1' after 40 ns;
    Data <= transport "11100011" after 25 ns, "ZZZZZZZZ" after 55 ns;

    wait for 60 ns; 
    Address <= "00011000";              -- RAM deselected
    wait for 40 ns;
    Address <= "00001000";              -- Read cycles
    Cs_b <= '0';
    wait for 40 ns;
    Address <= "00010000";
    Cs_b <= '1' after 40 ns;
    wait for 40 ns;
    Address <= "00011000";              -- RAM deselected
    wait for 40 ns;
    report "DONE";
  end process;
end test1;