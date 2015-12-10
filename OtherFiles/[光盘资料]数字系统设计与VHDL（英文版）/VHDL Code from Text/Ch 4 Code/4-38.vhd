library IEEE;
use IEEE.numeric_bit.all;

entity testmult is
end testmult;

architecture test1 of testmult is
component mult2C
  port(CLK, St: in bit;
       Mplier, Mcand: in unsigned(3 downto 0);
       Product: out unsigned(6 downto 0);
       Done: out bit);
end component;

constant N: integer := 11;
type arr is array(1 to N) of unsigned(3 downto 0);
type arr2 is array(1 to N) of unsigned(6 downto 0);
constant Mcandarr: arr := ("0111", "1101", "0101", "1101", "0111",
                   "1000", "0111", "1000", "0000", "1111", "1011");
constant Mplierarr: arr := ("0101", "0101", "1101", "1101", "0111",
                    "0111", "1000", "1000", "1101", "1111", "0000");
constant Productarr: arr2 := ("0100011", "1110001", "1110001",
                              "0001001", "0110001", "1001000",
                              "1001000", "1000000", "0000000",
                              "0000001", "0000000");
signal CLK, St, Done: bit;
signal Mplier, Mcand: unsigned(3 downto 0);
signal Product: unsigned(6 downto 0);
begin
  CLK <= not CLK after 10 ns;
  process
  begin
    for i in 1 to N loop
      Mcand <= Mcandarr(i);
      Mplier <= Mplierarr(i);
      St <= '1';
      wait until CLK = '1' and CLK'event;
      St <= '0';
      wait until Done = '0' and Done'event;
      assert Product = Productarr(i)	-- compare with expected answer
        report "Incorrect Product"
        severity error;  
     
    end loop;
    report "TEST COMPLETED";
  end process;
  mult1: mult2c port map(CLK, St, Mplier, Mcand, Product, Done);
end test1;