library IEEE;
use IEEE.numeric_bit.all;

entity test_squares is
  port(CLK: in bit);
end test_squares;

architecture test of test_squares is
  type FourBitNumbers is array (0 to 6) of unsigned (3 downto 0);
  type squareNumbers is array (0 to 6) of unsigned (7 downto 0);
  constant FN: FourBitNumbers := ("0001", "1000", "0011", "0010", "0101", "0000", "1111");
  signal answer: squareNumbers;
  signal length: integer := 6;

function squares (Number_arr: FourBitNumbers; length: positive)
  return squareNumbers is

variable SN: squareNumbers;
begin
loop1: for i in 0 to length loop
  SN(i) := Number_arr(i) * Number_arr(i);
end loop loop1;
return SN;
end squares;

begin
  process(CLK)
  begin
    if CLK = '1' and CLK'EVENT then
     answer <= squares(FN, length);
    end if;
  end process;
end test;
