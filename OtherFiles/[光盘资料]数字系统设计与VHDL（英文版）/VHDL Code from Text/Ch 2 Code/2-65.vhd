library IEEE;
use IEEE.numeric_bit.all;

entity parity_gen is
  port(X: in unsigned(3 downto 0);
       Y: out unsigned(4 downto 0));
end parity_gen;

architecture Table of parity_gen is
type OutTable is array(0 to 15) of bit;
signal ParityBit: bit;
constant OT: OutTable := ('1','0','0','1','0','1','1','0',
                          '0','1','1','0','1','0','0','1');
begin
  ParityBit <= OT(to_integer(X));
  Y <= X & ParityBit;
end Table;
