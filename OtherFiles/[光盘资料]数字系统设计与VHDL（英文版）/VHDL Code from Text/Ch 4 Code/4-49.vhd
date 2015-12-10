library IEEE;
use IEEE.numeric_bit.all;

entity scantest is
end scantest;

architecture test1 of scantest is
component scanner
  port(R0, R1, R2, R3, CLK: in bit;
       C0, C1, C2: inout bit;
       N0, N1, N2, N3, V: out bit);
end component;

type arr is array (0 to 23) of integer;           -- array of keys to test
constant KARRAY: arr := (2,5,8,0,3,6,9,11,1,4,7,10,1,2,3,4,5,6,7,8,9,10,11,0);
signal C0, C1, C2, V, CLK, R0, R1, R2, R3: bit;   -- interface signals
signal N: unsigned(3 downto 0);
signal KN: integer;                               -- key number to test
begin
  CLK <= not CLK after 20 ns;                     -- generate clock signal

  -- this section emulates the keypad
  R0 <= '1' when (C0='1' and KN=1) or (C1='1' and KN=2) or (C2='1' and KN=3)
        else '0';
  R1 <= '1' when (C0='1' and KN=4) or (C1='1' and KN=5) or (C2='1' and KN=6)
        else '0';
  R2 <= '1' when (C0='1' and KN=7) or (C1='1' and KN=8) or (C2='1' and KN=9)
        else '0';
  R3 <= '1' when (C0='1' and KN=10) or (C1='1' and KN=0) or (C2='1' and KN=11)
        else '0';

  process                               -- this section tests scanner
  begin
    for i in 0 to 23 loop               -- test every number in key array
      KN <= KARRAY(i);                  -- simulates keypress
      wait until (V = '1' and rising_edge(CLK));
      assert (to_integer(N) = KN)       -- check if output matches
        report "Numbers don't match"
        severity error;
      KN <= 15;                         -- equivalent to no key pressed
      wait until rising_edge(CLK);      -- wait for scanner to reset
      wait until rising_edge(CLK);
      wait until rising_edge(CLK);
    end loop;
    report "Test Complete.";
  end process;
  scanner1: scanner port map(R0,R1,R2,R3,CLK,C0,C1,C2,N(0),N(1),N(2),N(3),V);
                                        -- connect test1 to scanner
end test1;