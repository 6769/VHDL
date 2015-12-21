
--------------------------------------------------------------
 ------------------------------------------------------------
  --                clock_second.vhd
 ------------------------------------------------------------
--------------------------------------------------------------

--Intertime clock
library ieee;
use ieee.numeric_bit.all;

entity clock_second is
	port(clk:in bit ;
		second:buffer bit);
end entity clock_second;

architecture Distribution of clock_second is

signal counter_for_osc_signal:unsigned(31 downto 0);
begin
	process
   
	begin

		wait until clk'event and clk='1';
		if counter_for_osc_signal < 25--*1000*1000 
			then 
			counter_for_osc_signal<=counter_for_osc_signal+1;
			else counter_for_osc_signal<=(others=>'0');
				second<=not second;
				--here is the problem that second signal will result unflatten square wave,if using the commented mathod.
		end if;
	end process;
--	second<='1' when counter_for_osc_signal> 25*1000*1000 --High_percent_of_counter
--		else '0' ;

-- timing analysis here ...
end architecture Distribution;



--------------------------------------------------------------
 ------------------------------------------------------------
  --                counter_max10.vhd
 ------------------------------------------------------------
--------------------------------------------------------------

library ieee;
use ieee.numeric_bit.all;

entity counter_max10 is
	port(clk:in bit ;reset:in bit;limit:in bit;
		carry:out bit;
		CountedNumber:buffer unsigned(3 downto 0));
end entity counter_max10;

architecture behavior of counter_max10 is

begin
	carry<=CountedNumber(3)and CountedNumber(0)and limit;--"1001" 
	process(clk,reset,limit)
	begin
		if(reset='0') then CountedNumber<=(others=>'0');
		elsif (clk'event and clk='1' and limit='1') then 
			if(CountedNumber< 9) then	CountedNumber<=CountedNumber+1;
			else CountedNumber<="0000";
			end if;
		end if;
	end process;
end architecture behavior;

--------------------------------------------------------------
 ------------------------------------------------------------
  --                Segment7Decoder.vhd
 ------------------------------------------------------------
--------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Segment7Decoder is
	port (bcd	: in bit_vector(3 downto 0);  --BCD input
        segment7 : out bit_vector(7 downto 1)  -- 7 bit decoded output.
    );
end Segment7Decoder;
--'a' corresponds to MSB of segment7 and g corresponds to LSB of segment7.
architecture Behavioral of Segment7Decoder is

begin
process (bcd)
BEGIN

	case  bcd is
			when "0000"=> segment7 <="1000000";  -- '0'
			when "0001"=> segment7 <="1111001";  -- '1'
			when "0010"=> segment7 <="0100100";  -- '2'
			when "0011"=> segment7 <="0110000";  -- '3'
			when "0100"=> segment7 <="0011001";  -- '4' 
			when "0101"=> segment7 <="0010010";  -- '5'
			when "0110"=> segment7 <="0000010";  -- '6'
			when "0111"=> segment7 <="1111000";  -- '7'
			when "1000"=> segment7 <="0000000";  -- '8'
			when "1001"=> segment7 <="0010000";  -- '9'
            when "1010"=> segment7 <="0001000"; --'A'
            when "1011"=> segment7 <="0000011"; --'b'
            when "1100"=> segment7 <="0100111"; --'c'
            when "1101"=> segment7 <="0100001"; --'d'
            when "1110"=> segment7 <="0000110"; --'E'
            when "1111"=> segment7 <="0001110"; --'f'
			 --nothing is displayed when a number more than 9 is given as input. 
			when others=> segment7 <="1111111"; 
	end case;
end process;

end Behavioral;

--------------------------------------------------------------
 ------------------------------------------------------------
  --                Threebit_BCD_counter.vhd
 ------------------------------------------------------------
--------------------------------------------------------------

library ieee;
use ieee.numeric_bit.all;

entity Threebit_BCD_counter is
	port( clk:in bit;reset:in bit;
	Counter_Result:out unsigned(11 downto 0) );
end entity Threebit_BCD_counter;

architecture combination of Threebit_BCD_counter is

signal midcarry:bit_vector(2 downto 1);
signal mid_second:bit;

alias hex0:unsigned(3 downto 0) is Counter_Result(3 downto 0);
alias hex1:unsigned(3 downto 0) is Counter_Result(7 downto 4);
alias hex2:unsigned(3 downto 0) is Counter_Result(11 downto 8);
component counter_max10
	port(clk:in bit ;reset:in bit;limit:in bit;
		carry:out bit;
		CountedNumber:buffer unsigned(3 downto 0));
end component;

component clock_second is
	port(clk:in bit ;
		second:buffer bit);
end component;

begin
	High50MhzToSecond:clock_second port map(clk,mid_second);
	hex0_lable:counter_max10 port map(mid_second,reset,'1',midcarry(1),hex0);
    hex1_lable:counter_max10 port map(mid_second,reset,midcarry(1),midcarry(2),hex1 );
    hex2_lable:counter_max10 port map(mid_second,reset,midcarry(2),open ,hex2 );


end architecture combination;

--------------------------------------------------------------
 ------------------------------------------------------------
  --                View_output.vhd
 ------------------------------------------------------------
--------------------------------------------------------------

library ieee;
use ieee.numeric_bit.all;

entity View_output is
	port(clk:in bit; reset:in bit;
	hex0_out:out bit_vector(7 downto 0);
	hex1_out:out bit_vector(7 downto 0);
	hex2_out:out bit_vector(7 downto 0));
end entity View_output;

architecture combination_of_View of View_output is
--type 
component Threebit_BCD_counter is
	port( clk:in bit;reset:in bit;
	Counter_Result:out unsigned(11 downto 0) );
end component;
component Segment7Decoder is
	port (bcd	: in bit_vector(3 downto 0);  --BCD input
        segment7 : out bit_vector(7 downto 1)  -- 7 bit decoded output.
    );
end component;
signal mid_12bit_result:unsigned(11 downto 0);
alias mid_hex0:unsigned(3 downto 0) is mid_12bit_result(3 downto 0);
alias mid_hex1:unsigned(3 downto 0) is mid_12bit_result(7 downto 4);
alias mid_hex2:unsigned(3 downto 0) is mid_12bit_result(11 downto 8);
begin
	Synthesis:Threebit_BCD_counter port map(clk,reset,mid_12bit_result);
	hex0_out(0)<='1';
	hex1_out(0)<='1';
	hex2_out(0)<='1';
	hex0_display:Segment7Decoder port map(bit_vector(mid_hex0),hex0_out(7 downto 1));
	hex1_display:Segment7Decoder port map(bit_vector(mid_hex1),hex1_out(7 downto 1));
	hex2_display:Segment7Decoder port map(bit_vector(mid_hex2),hex2_out(7 downto 1));
end architecture combination_of_View;
