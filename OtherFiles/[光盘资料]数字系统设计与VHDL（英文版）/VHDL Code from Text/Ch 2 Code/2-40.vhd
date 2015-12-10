library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
entity Adder4_v3 is
  port(A, B: in std_logic_vector(3 downto 0); Ci: in std_logic; --Inputs
       S: out std_logic_vector(3 downto 0); Co: out std_logic); --Outputs
end Adder4_v3;

architecture overload of Adder4_v3 is
signal Sum5: std_logic_vector(4 downto 0);
begin
  Sum5 <= '0' & A + B + Ci; --adder
  S <= Sum5(3 downto 0);
  Co <= Sum5(4);
end overload;	
