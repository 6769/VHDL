library ieee;
use ieee.numeric_bit.all;

entity View is
    port(Rb, Reset, CLK: in bit;
    Win, Lose: out bit;
    hex0,hex1:out unsigned(7 downto 0)
    );
    
end entity View;
architecture Combination of View is

component DiceGame_controller  
  port(Rb, Reset, CLK: in bit;
       Sum: in integer range 2 to 12;
       Roll, Win, Lose: out bit);
end component;

component Counter1to6 
    port(clk,limit:in bit;
    Carry:out bit;
    Count:out integer range 6 downto 1);
end component;

component Adder 
    port(add1,add2:in integer range 6 downto 1;
    Sum:out integer range 12 downto 2);
end component;

component Segment7Decoder is
	port (bcd	: in unsigned(3 downto 0);  --BCD input
        segment7 : out unsigned(6 downto 0)  -- 7 bit decoded output.
    );
end  component;
signal mid_Roll,mid_Carry,mid_Lose,mid_Win:bit;
signal mid_Sum:integer range 12 downto 2;
signal mid_hex0,mid_hex1:integer range 6 downto 1;
signal mid_hex0_unsigned,mid_hex1_unsigned:unsigned(3 downto 0);
signal mid_Carry_control:bit;
begin
    label_control:DiceGame_controller port map(Rb,Reset,CLK,mid_Sum,mid_Roll,mid_Win,mid_Lose);
    label_counter_hex0:Counter1to6    port map(CLK,mid_Roll,mid_Carry,mid_hex0);
    label_counter_hex1:Counter1to6    port map(CLK,mid_Carry_control,open,    mid_hex1);
    label_adder:Adder                 port map(mid_hex0,mid_hex1,mid_Sum);
    Dispaly_hex0:Segment7Decoder      port map(mid_hex0_unsigned,hex0(7 downto 1));
    Dispaly_hex1:Segment7Decoder      port map(mid_hex1_unsigned,hex1(7 downto 1));
    mid_Carry_control<=(mid_Carry and mid_Roll);
    mid_hex0_unsigned<=to_unsigned(mid_hex0,4);
    mid_hex1_unsigned<=to_unsigned(mid_hex1,4);
    hex0(0)<='1';--shutdown Dot..
    hex1(0)<='1';
	
	Win<=mid_Win;
	Lose<=mid_Lose;
end architecture Combination ;











