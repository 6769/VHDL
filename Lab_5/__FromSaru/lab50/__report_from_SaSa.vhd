
--------------------------------------------------------------
 ------------------------------------------------------------
  --                adder.vhd
 ------------------------------------------------------------
--------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity adder is
  port(addend1,addend2:in std_logic_vector(3 downto 0);
  sum:out std_logic_vector(3 downto 0));
end adder;

architecture add of adder is
begin
  sum<=addend1+addend2;
end add;

--------------------------------------------------------------
 ------------------------------------------------------------
  --                comparator.vhd
 ------------------------------------------------------------
--------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity comparator is
  port(point:in std_logic_vector(3 downto 0);
       sum:in std_logic_vector(3 downto 0);
       eq:out bit);
end comparator;

architecture compare of comparator is
begin
--could be alternatived by MUX statements...3 lines...--
  process(point,sum)
  begin
    if point=sum then
      eq<='1';
    else eq<='0';
    end if;
  end process;
end compare;

--------------------------------------------------------------
 ------------------------------------------------------------
  --                control.vhd
 ------------------------------------------------------------
--------------------------------------------------------------

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

--------------------------------------------------------------
 ------------------------------------------------------------
  --                counter_1_6.vhd
 ------------------------------------------------------------
--------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity counter_1_6 is
  port(clk_50m,roll:in bit;
       out_count:inout std_logic_vector(3 downto 0));
end counter_1_6;

architecture count of counter_1_6 is

signal count:std_logic_vector(3 downto 0):="0000";

begin
  process(clk_50m,roll,count)
  begin
  if roll='1' then
    if clk_50m'event and clk_50m='0' then
      if count>"0100" then
        count<="0001";
		else count<=count+1;
      end if;
    end if;
  else out_count<=count;
  end if;
  end process;
end count;

--------------------------------------------------------------
 ------------------------------------------------------------
  --                decoder_1_6.vhd
 ------------------------------------------------------------
--------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY decoder_1_6 IS
PORT(
    m:IN STD_LOGIC_vector(3 downto 0);
    led_vector:out bit_vector(7 DOWNTO 0));
END decoder_1_6;

ARCHITECTURE decoder_architecture OF decoder_1_6 IS
BEGIN
    PROCESS(m)
    BEGIN
     CASE m IS
        WHEN "0001" => led_vector<="11111001";--F9=>1
        WHEN "0010" => led_vector<="10100100";--A4=>2
        WHEN "0011" => led_vector<="10110000";--B0=>3
        WHEN "0100" => led_vector<="10011001";--99=>4
        WHEN "0101" => led_vector<="10010010";--92=>5
        WHEN "0110" => led_vector<="10000010";--82=>6
        WHEN others => led_vector<="11111111";--FF=>²»ÁÁ
    END CASE;
    END PROCESS;
END decoder_architecture;

--------------------------------------------------------------
 ------------------------------------------------------------
  --                lab50.vhd
 ------------------------------------------------------------
--------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity lab50 is
  port(reset,rb,clk_50m,clk_28m:in bit;
  win,lose:out bit;
  led1,led2:out bit_vector(7 downto 0));
end lab50;

architecture allmap of lab50 is
                     
component counter_1_6 is
  port(clk_50m,roll:in bit;
       out_count:inout std_logic_vector(3 downto 0));
end component;

component decoder_1_6 IS
PORT(m:IN STD_LOGIC_vector(3 downto 0);
     led_vector:out bit_vector(7 DOWNTO 0));
end component;

component adder is
  port(addend1,addend2:in std_logic_vector(3 downto 0);
       sum:out std_logic_vector(3 downto 0));
end component;

component point_register is
  port(sp:in bit;
       point:out std_logic_vector(3 downto 0);
       sum:in std_logic_vector(3 downto 0));
end component;

component comparator is
  port(point:in std_logic_vector(3 downto 0);
       sum:in std_logic_vector(3 downto 0);
       eq:out bit);
end component;

component test_logic is
  port(sum:in std_logic_vector(3 downto 0);
       d7,d711,d2312:out bit);
end component;

component control is
  port(reset,rb,eq,d7,d711,d2312:in bit;
  roll,win,lose,sp:out bit);
end component;

signal roll,eq,d7,d711,d2312,sp:bit;
signal count1,count2,sum,point:std_logic_vector(3 downto 0);

begin
decoder1:decoder_1_6 port map(m=>count1,led_vector=>led1);
decoder2:decoder_1_6 port map(m=>count2,led_vector=>led2);
counter1:counter_1_6 port map(clk_50m=>clk_50m,roll=>roll,out_count=>count1);
counter2:counter_1_6 port map(clk_50m=>clk_28m,roll=>roll,out_count=>count2);
add:adder port map(addend1=>count1,addend2=>count2,sum=>sum);
pr:point_register port map(sp=>sp,point=>point,sum=>sum);
compare:comparator port map(point=>point,sum=>sum,eq=>eq);
test:test_logic port map(sum=>sum,d7=>d7,d711=>d711,d2312=>d2312);
con:control port map(reset=>reset,rb=>rb,
                     eq=>eq,d7=>d7,d711=>d711,d2312=>d2312,
                     roll=>roll,win=>win,lose=>lose,sp=>sp);
end allmap;

--------------------------------------------------------------
 ------------------------------------------------------------
  --                point_register.vhd
 ------------------------------------------------------------
--------------------------------------------------------------

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

--------------------------------------------------------------
 ------------------------------------------------------------
  --                test_logic.vhd
 ------------------------------------------------------------
--------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity test_logic is
  port(sum:in std_logic_vector(3 downto 0);
       d7,d711,d2312:out bit);
end test_logic;

architecture test of test_logic is
begin
  process(sum)
  begin
    if sum="0111" then
      d7<='1';
    else d7<='0';
    end if;
    if sum="0111" or sum="1011" then
      d711<='1';
    else d711<='0';
    end if;
    if sum="0010" or sum="0011" or sum="1100" then
      d2312<='1';
    else d2312<='0';
    end if;
  end process;
end test;
