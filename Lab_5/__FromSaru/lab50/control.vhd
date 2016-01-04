library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity control is
  port(reset,rb,eq,d7,d711,d2312:in bit;
  roll,win,lose,sp:out bit);
end control;

architecture con of control is
signal count:std_logic_vector(3 downto 0):="0000";
signal w,l:bit;
begin
  process(reset,rb)
  begin
    if reset='0' then
      sp<='1';
      count<="0000";
    elsif rb'event and rb='1' then
      count<=count+1;
    elsif rb'event and rb='0' and count="0001" then
      sp<='0';
    end if;
    roll<=not rb;
  end process;
  
  process(count,eq,d7,d711,d2312)
  begin
  --if w='0' and l='0' then
    if count="0000" then
      w <='0';l <='0';
    elsif count="0001" then
      w <=d711;l <=d2312;
    else
      w <=eq;l <=d7;
    end if;
  --end if;
  end process;
  win<=w;
  lose<=l;
end con;