--partA
--file for first VHDL Documents.!!!
entity NumberAnDisplay is
	port(
		-- Input ports
		V	: in  bit_vector(3 downto 0);
		-- Output ports
		z	: buffer bit;
		M	: buffer bit_vector(3 downto 0);
		
		-- 7 Segment Display
		segment7:out bit_vector(6 downto 0);
		--segment7:out bit_vector();
		segment7_point:out bit :='1';
		
		segment7_1:out bit_vector(6 downto 0);
		segment7_1_point:out bit :='1'
	);
end NumberAnDisplay;

architecture CircuitA_Mux of NumberAnDisplay is 
	signal midM : bit_vector(2 downto 0);
	--assignment about <:='0000'> correspond?
begin
	z<= V(3)and (V(2)or V(1));
	--circuitA part 
	midM(0)<=V(0);
	midM(1)<=not V(1);
	midM(2)<=V(2)and V(1);

	--Multiplexer part 
	M(3)<=(not z) and V(3) ;
	M(2)<=((not z) and V(2)) or (z and midM(2));
	M(1)<=((not z) and V(1)) or (z and midM(1));
	M(0)<=((not z) and V(0)) or (z and midM(0));
	
	--7 Segment Display
	process (M)
	BEGIN
		case  M is
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
			 --nothing is displayed when a number more than 9 is given as input. 
			when others=> segment7 <="1111111"; 
		end case;
	end process;
	
	process (z)
	BEGIN		
		case  z is
			when '0'=> segment7_1 <="1000000";  -- '0'
			when '1'=> segment7_1 <="1111001";  -- '1'
			--nothing is displayed when a number more than 9 is given as input. 
			when others=> segment7 <="1111111"; 
		end case;
	end process;
end CircuitA_Mux;


--------------------------------------------------------
--                      partB                         --
--------------------------------------------------------
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
entity Bcd2digitAdder is
	port (adder1,adder2:in bit_vector(7 downto 0);
			result:out bit_vector(7 downto 0);
			finalCarry:out bit);
end entity Bcd2digitAdder;

architecture structure of Bcd2digitAdder is

	signal mid_carry_adjust:bit;
	signal midResult:bit_vector(7 downto 0);
	signal mid_carry:bit_vector(1 downto 0);
	
	--include FullAdderl;
	component Adder4 
	port(A,B:in bit_vector (3 downto 0);
			cin:in bit ;
			S:out bit_vector(3 downto 0);
			cout:buffer bit);
	end component;
	
	
	--include adjust part
	component adjustAdder4 
	port(origin:in bit_vector(3 downto 0);
		adjusted:out bit_vector(3 downto 0);
		carryIn:in bit;
		carryAdjusted:out bit);
	end component;
	
begin 
	-- 4bits FullAdder
	FA4_low :Adder4 port map(adder1(3 downto 0),adder2(3 downto 0),'0',				  
									midResult(3 downto 0),mid_carry(0));
	FA4_high:Adder4 port map(adder1(7 downto 4),adder2(7 downto 4),mid_carry_adjust,
									midResult(7 downto 4),mid_carry(1));
	--adjust 4bits 
	ADJust4_low: adjustAdder4 port map(midResult(3 downto 0),result(3 downto 0),mid_carry(0),mid_carry_adjust);
	ADjust4_high:adjustAdder4 port map(midResult(7 downto 4),result(7 downto 4),mid_carry(1),finalCarry);
	
	--output in result(7 downto 0),finalcarry,
	
end architecture structure;

entity adjustAdder4 is
	port(origin:in bit_vector(3 downto 0);
	adjusted:out bit_vector(3 downto 0);
	carryIn:in bit;
	carryAdjusted:out bit);
end adjustAdder4;

architecture conversion of adjustAdder4 is
	component Adder4 
	port(A,B:in bit_vector (3 downto 0);
			cin:in bit ;
			S:out bit_vector(3 downto 0);
			cout:buffer bit);
	end component;
	signal z:bit:='0';
	signal never_use:bit;
	signal S_mid:bit_vector(3 downto 0);
begin
	z<=carryIn or (origin(3)and (origin(2) or origin(1)) );
	carryAdjusted<=z;
	FA4:Adder4 port map (origin,"0110",'0',S_mid,never_use);
	adjusted<=origin when z='0'
			else s_mid ;
end conversion;

--another function is adjust BCD ,like the instruct DA in 8051;
--A pure 4bits fullAdder;
entity Adder4 is 
	port(A,B:in bit_vector (3 downto 0);
			cin:in bit ;
			S:out bit_vector(3 downto 0);
			cout:buffer bit);
end Adder4;

architecture bit4FullAdder of Adder4 is
	component FullAdder
		port(a,b,cin:in  bit ;
			   s,cout:out bit );
	end component;
	signal C:bit_vector(3 downto 1);--internal carry bit ;
	
begin
	FA0:FullAdder port map(A(0),B(0),cin ,S(0),C(1));
	FA1:FullAdder port map(A(1),B(1),C(1),S(1),C(2));
	FA2:FullAdder port map(A(2),B(2),C(2),S(2),C(3));
	FA3:FullAdder port map(A(3),B(3),C(3),S(3),cout);	
	
end bit4FullAdder;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Segment7Decoder is
	port (bcd			: in bit_vector(3 downto 0);  --BCD input
        segment7 : out bit_vector(6 downto 0)  -- 7 bit decoded output.
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
			 --nothing is displayed when a number more than 9 is given as input. 
			when others=> segment7 <="1111111"; 
	end case;
end process;
end Behavioral;

--------------------------------------------------------
---                  partC                           ---
--------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
--finally synthesis all component;
entity Input_Display is
	port(adder1,adder2:in std_logic_vector(7 downto 0);
		adder1_hex_display,adder2_hex_display:out std_logic_vector(15 downto 0);
		sum:	out std_logic_vector(23 downto 0)
		
		);
end entity Input_Display;

architecture combination of Input_Display is

	--signal A0,B0,T0,Z0,A1,B1,T1,Z1,S0,S1,S2:std_logic_vector(3 downto 0):="0000";
	signal A0,B0,T0,Z0,A1,B1,T1,Z1,S0,S1,S2:std_logic_vector(3 downto 0);
	signal c1,c2:std_logic;	
	
	
	component Segment7Decoder 
	port (bcd	: in std_logic_vector(3 downto 0);  --BCD input
        segment7 : out std_logic_vector(6 downto 0)  -- 7 bit decoded output.
    );
	end component;
begin
	A0<=adder1(3 downto 0);B0<=adder2(3 downto 0);
	A1<=adder1(7 downto 4);B1<=adder2(7 downto 4);
	process(adder1,adder2)
	begin
		T0<=A0+B0;
		if T0>9 then Z0<="1010";c1<='1';
			else Z0<="0000";c1<='0';
		end if;
		S0<=T0-Z0;
		
		T1<=A1+B1+c1;
		if(T1>9) then Z1<="1010";c2<='1';
			else Z1<="0000";c2<='0';
		end if;
		S1<=T1-Z1;
		S2<="000"&c2;
	end process;
	--adder1
	Display_adder1_lower:Segment7Decoder port map(A0,adder1_hex_display(7  downto 1));
	Display_adder1_higer:Segment7Decoder port map(A1,adder1_hex_display(15 downto 9));
	
	--adder2
	Display_adder2_lower:Segment7Decoder port map(B0,adder2_hex_display(7 downto 1));
	Display_adder2_higer:Segment7Decoder port map(B1,adder2_hex_display(15 downto 9));
	
	--result
	Res_lower:Segment7Decoder port map(S0,sum(7  downto 1));
	Res_higer:Segment7Decoder port map(S1,sum(15 downto 9));
	Res_tower:Segment7Decoder port map(S2,sum(23 downto 17));
	
	--point
	sum(0)<='1';
	sum(8)<='1';
	sum(16)<='1';
	
	adder1_hex_display(0)<='1';
	adder1_hex_display(8)<='1';
	
	adder2_hex_display(0)<='1';
	adder2_hex_display(8)<='1';
end architecture combination;
