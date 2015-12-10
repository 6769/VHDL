library IEEE;
use IEEE.numeric_bit.all;

entity multiplier is
  port(A, B: in unsigned (31 downto 0);
       C: out unsigned (63 downto 0));
end multiplier;

architecture mult of multiplier is
begin
  C <= A * B;
end mult;
