
-- SRAM Read-Write System model
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity RAM6116_system is
end RAM6116_system;

architecture RAMtest of RAM6116_system is
component RAM6116 is
  port(Cs_b, We_b, Oe_b: in std_logic;
       Address: in unsigned(7 downto 0);
       IO: inout unsigned(7 downto 0));
end component RAM6116;

signal state, next_state: integer range 0 to 3;
signal inc_adrs, inc_data, ld_data, en_data, Cs_b, clk, Oe_b, done: std_logic := '0';
signal We_b: std_logic := '1';                       -- initialize to read mode
signal Data: unsigned(7 downto 0);                   -- data register
signal Address: unsigned(7 downto 0) := "00000000";  -- address register
signal IO: unsigned(7 downto 0);             -- I/O bus
begin
  RAM1: RAM6116 port map (Cs_b, We_b, Oe_b, Address, IO);
  control: process(state, Address)
  begin
    --initialize all control signals (RAM always selected)
    ld_data <= '0'; inc_data <= '0'; inc_adrs <= '0'; en_data <='0';
    done <= '0'; We_b <= '1'; Cs_b <= '0'; Oe_b <= '1';
    --start SM chart here
    case state is
      when 0 => Oe_b <= '0'; ld_data <= '1'; next_state <= 1;
      when 1 => inc_data <= '1'; next_state <= 2;
      when 2 => We_b <= '0'; en_data <= '1'; inc_adrs <= '1'; next_state <= 3;
      when 3 =>
        if (Address = "00100000") then done <= '1'; next_state <= 3;
        else next_state <= 0;
        end if;
    end case;
  end process control;

  --The following process is executed on the rising edge of a clock.
  register_update: process(clk)   -- process to update data register
  begin
    if rising_edge(clk) then
      state <= next_state;
      if (inc_data = '1') then data <= data + 1; end if;
                            -- increment data in data register
      if (ld_data = '1') then data <= Unsigned(IO); end if;
                            -- load data register from bus
      if (inc_adrs = '1') then Address <= Address + 1 after 1 ns; end if;
                            -- delay added to allow completion of memory write
    end if;
  end process register_update;

  -- Concurrent statements
  clk <= not clk after 100 ns;
  IO <= data when en_data = '1'
    else "ZZZZZZZZ";
end RAMtest;
