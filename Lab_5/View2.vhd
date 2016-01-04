library ieee;
use ieee.numeric_bit.all;

entity View2 is 
	port(
	Rb, Reset, CLK: in bit;
    Win, Lose:out bit;
    hex0,hex1:out unsigned(7 downto 0)
    );    
end entity View2;
architecture Sys of View2 is
component Segment7Decoder 
	port (bcd	: in unsigned(3 downto 0);  --BCD input
        segment7 : out unsigned(6 downto 0)  -- 7 bit decoded output.
    );
end component;

component Roll_Sum 
    port(Rb,CLK,Reset:in bit;
    hex0,hex1:out integer range 6 downto 1;
    Sum:out integer range 12 downto 2
    );
end component;

component PointerRegister 
	port(
	Sum:in integer range 2 to 12;
	Sp:in bit;
	LockedSum:out integer range 2 to 12
	);
end component;
component  Compartor  
	port(
	Sum,LockedSum:in integer range 2 to 12;	
	Eq,D7,D711,D2312:out bit
	);
end component;
component Controller 
	port(
	Rb,Reset,  Eq,D7,D711,D2312,CLK:in bit;
	Sp,Roll,Win,Lose,Clear:out bit);
end component;

signal mid_hex0,mid_hex1:integer range 6 downto 1;
signal mid_hex0_unsigned,mid_hex1_unsigned:unsigned(3 downto 0);
signal mid_Sum,mid_LockedSum:integer range 12 downto 2;
signal mid_Roll,mid_Clear,mEq,mD7,mD711,mD2312,mid_Sp:bit;

begin
	label_Controller:Controller		  port map(Rb,Reset, mEq,mD7,mD711,mD2312,CLK,  mid_Sp,mid_Roll,Win,Lose,mid_Clear);
	label_Roll_sum:Roll_Sum           port map(mid_Roll,CLK,mid_Clear,mid_hex0,mid_hex1,mid_Sum);
	
	label_Pointer:PointerRegister	  port map(mid_Sum,mid_Sp,mid_LockedSum);
	label_Compartoe:Compartor 		  port map(mid_Sum,mid_LockedSum,mEq,mD7,mD711,mD2312);
	Dispaly_hex0:Segment7Decoder      port map(mid_hex0_unsigned,hex0(7 downto 1));
    Dispaly_hex1:Segment7Decoder      port map(mid_hex1_unsigned,hex1(7 downto 1));
	
    
    mid_hex0_unsigned<=to_unsigned(mid_hex0,4);
    mid_hex1_unsigned<=to_unsigned(mid_hex1,4);
    hex0(0)<='1';--shutdown Dot..
    hex1(0)<='1';
	
	
end architecture Sys;