library IEEE;
use IEEE.numeric_bit.all;

entity testsdiv is
end testsdiv;

architecture test1 of testsdiv is
component sdiv
  port(CLK, St: in bit;
       Dbus: in unsigned(15 downto 0);
       Quotient: out unsigned(15 downto 0);
       V, Rdy: out bit);
end component;

constant N: integer := 12;                       -- test sdiv1 N times
type arr1 is array(1 to N) of unsigned(31 downto 0);
type arr2 is array(1 to N) of unsigned(15 downto 0);
constant dividendarr: arr1 := (X"0000006F", X"07FF00BB", X"FFFFFE08",
     X"FF80030A", X"3FFF8000", X"3FFF7FFF", X"C0008000", X"C0008000",
     X"C0008001", X"00000000", X"FFFFFFFF", X"FFFFFFFF");
constant divisorarr: arr2 := (X"0007", X"E005", X"001E", X"EFFA", X"7FFF",
   X"7FFF", X"7FFF", X"8000", X"7FFF", X"0001", X"7FFF", X"0000");
signal CLK, St, V, Rdy: bit;
signal Dbus, Quotient, divisor: unsigned(15 downto 0);
signal Dividend: unsigned(31 downto 0);
signal Count: integer range 0 to N;

begin
  CLK <= not CLK after 10 ns;
  process
  begin
    for i in 1 to N loop
      St <= '1';
      Dbus <= dividendarr(i)(31 downto 16);
      wait until (CLK'event and CLK = '1');
      Dbus <= dividendarr(i)(15 downto 0);
      wait until (CLK'event and CLK = '1');
      Dbus <= divisorarr(i);
      St <= '0';
      dividend <= dividendarr(i)(31 downto 0);   -- save dividend for listing
      divisor <= divisorarr(i);                  -- save divisor for listing
      wait until (Rdy = '1');
      count <= i;                                -- save index for triggering
    end loop;
    report "DONE";
  end process;
  sdiv1: sdiv port map(CLK, St, Dbus, Quotient, V, Rdy);
end test1;