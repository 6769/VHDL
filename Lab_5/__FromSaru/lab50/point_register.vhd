library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity point_register is
	--latch the last value--
  port(sp:in bit;
  point:out std_logic_vector(3 downto 0):="0000";
  sum:in std_logic_vector(3 downto 0));
end point_register;

architecture point of point_register is
--signal count:bit;
begin
   process(sp,sum)
   begin
     if sp='0' then
       --count<='0';
     elsif sp='1' then
       --count<='1';
       point<=sum;       
     end if;
   end process;
end point;