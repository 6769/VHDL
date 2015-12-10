library IEEE;
use IEEE.numeric_bit.all;

entity Adder4_v2 is
  port(A, B: in unsigned(3 downto 0); Ci: in bit;  -- Inputs
       S: out unsigned(3 downto 0); Co: out bit);  -- Outputs
end Adder4_v2;

architecture overload of Adder4_v2 is
signal Sum5: unsigned(4 downto 0);
begin
  Sum5 <= '0' & A + B + unsigned'(0=>Ci);  -- adder
  S <= Sum5(3 downto 0);
  Co <= Sum5(4);
end overload;	
