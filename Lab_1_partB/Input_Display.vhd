library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
--finally synthesis all component;
entity Input_Display is
	port(adder1,adder2:in bit_vector(7 downto 0);
		adder1_hex_display,adder2_hex_display:out bit_vector(15 downto 0);
		sum:out bit_vector(23 downto 0)
		);
end entity Input_Display;

architecture combination of Input_Display is
	
	--bcd4-adder;
	component Bcd2digitAdder 
	port (adder1,adder2:in bit_vector(7 downto 0);
			result:out bit_vector(7 downto 0);
			finalCarry:out bit);
	end component;
	
	--7segment decoder;
	component	 Segment7Decoder is
	port (bcd			: in bit_vector(3 downto 0);  --BCD input
        segment7 : out bit_vector(6 downto 0)  -- 7 bit decoded output.
    );
	end component;
	
	signal result_in_bcd:bit_vector(7 downto 0);
	signal HighBit:bit;
	signal tower:bit_vector(3 downto 0):="0000";
	signal point_value:bit:='1';
begin
	tower(0)<= HighBit;
	Bcdadder:Bcd2digitAdder port map(adder1,adder2,result_in_bcd,HighBit);
	--display Adder1;
		--lower 4
	Dis7Segment_adder1_lower:Segment7Decoder port map(adder1(3 downto 0),adder1_hex_display(7 downto 1));
		--higher 4
	Dis7Segment_adder1_higer:Segment7Decoder port map(adder1(7 downto 4),adder1_hex_display(15 downto 9));
		--point in bit 8,0
	
	--display Adder2 ;
		--lower 4
	Dis7Segment_adder2_lower:Segment7Decoder port map(adder2(3 downto 0),adder2_hex_display(7 downto 1));
		--higher 4
	Dis7Segment_adder2_higer:Segment7Decoder port map(adder2(7 downto 4),adder2_hex_display(15 downto 9));
	
	--display result_in_bcd
	Dis7Segment_result_lower:Segment7Decoder port map(result_in_bcd(3 downto 0),sum( 7 downto 1));
	Dis7Segment_result_higer:Segment7Decoder port map(result_in_bcd(7 downto 4),sum(15 downto 9));
	Dis7Segment_result_tower:Segment7Decoder port map(tower							,sum(23 downto 17));
		--point in bit 16,8,0;
		
	--reset All of Point in segment ;
	adder1_hex_display(0)<=point_value;
	adder1_hex_display(8)<=point_value;
	
	adder2_hex_display(0)<=point_value;
	adder2_hex_display(8)<=point_value;
	
	sum(0)<=point_value;
	sum(8)<=point_value;
	sum(16)<=point_value;
end architecture combination;