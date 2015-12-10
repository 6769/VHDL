library IEEE;
use IEEE.numeric_bit.all;

entity examples is
  port(signal clock: in bit;
       signal A, B: in signed(3 downto 0);
       signal ge: out boolean;
       signal acc: inout signed(3 downto 0) := "0000";
       signal count: inout unsigned(3 downto 0) := "0000");
end examples;

architecture x1 of examples is
begin
  ge <= (A >= B);  -- 4-bit comparator
  process
  begin
    wait until clock'event and clock = '1';
    acc <= acc + B;  -- 4-bit register and 4-bit adder
    count <= count + 1;  -- 4-bit counter
  end process;
end x1;
