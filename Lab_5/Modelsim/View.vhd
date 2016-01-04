library ieee;
use ieee.numeric_bit.all;
use ieee.std_logic_1164.all;

entity View is
    port(
	Rb, Reset, CLK: in bit;
    Win, Lose:out bit;
    hex0,hex1:out unsigned(7 downto 0)
    );    
end entity View;

architecture Combination of View is
component clock_signal_per_second is
    port(clk:in bit;
	second_output:buffer bit);
end component;
component DiceGame_controller_text 
  port(Rb, Reset, CLK: in bit;
       Sum: in integer range 2 to 12;
       Roll, Win, Lose: out bit);
end component;

component Segment7Decoder is
	port (bcd	: in unsigned(3 downto 0);  --BCD input
        segment7 : out unsigned(6 downto 0)  -- 7 bit decoded output.
    );
end  component;

component Roll_Sum is 
    port(Rb,CLK,Reset:in bit;
    hex0,hex1:out integer range 6 downto 1;
    Sum:out integer range 12 downto 2
    );
end component;

signal mid_Roll,mid_Carry,mid_Lose,mid_Win,mid_CLK:bit;
signal mid_Sum:integer range 12 downto 2;
signal mid_hex0,mid_hex1:integer range 6 downto 1;
signal mid_hex0_unsigned,mid_hex1_unsigned:unsigned(3 downto 0);

begin
	label_clock:clock_signal_per_second port map(CLK,mid_CLK);
    label_control:DiceGame_controller_text port map(Rb,Reset,mid_CLK,mid_Sum,mid_Roll,mid_Win,mid_Lose);
    label_Roll_sum:Roll_Sum           port map(mid_Roll,mid_CLK,Reset,mid_hex0,mid_hex1,mid_Sum);
    Dispaly_hex0:Segment7Decoder      port map(mid_hex0_unsigned,hex0(7 downto 1));
    Dispaly_hex1:Segment7Decoder      port map(mid_hex1_unsigned,hex1(7 downto 1));
	
    
    mid_hex0_unsigned<=to_unsigned(mid_hex0,4);
    mid_hex1_unsigned<=to_unsigned(mid_hex1,4);
    hex0(0)<='1';--shutdown Dot..
    hex1(0)<='1';
	
	Win<=mid_Win;
	Lose<=mid_Lose;
end architecture Combination ;











