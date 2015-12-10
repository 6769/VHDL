library IEEE;
use IEEE.numeric_bit.all;

entity Adder32 is
  port(A, B: in unsigned(31 downto 0); Ci: in bit;  -- Inputs
       S: out unsigned(31 downto 0); Co: out bit);  -- Outputs
end Adder32;

architecture overload of Adder32 is
signal Sum33: unsigned(32 downto 0);
begin
  Sum33 <= '0' & A + B + unsigned'(0=>Ci);          -- adder
  S <= Sum33(31 downto 0);
  Co <= Sum33(32);
end overload;
