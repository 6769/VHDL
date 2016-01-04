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