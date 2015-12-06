--------------------------------------------------------
---------------------partC------------------------------
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
	signal A1,B1,A0,B0,Z0,Z1,S0,S1,S2:std_logic_vector(3 downto 0);
	signal T0,T1:std_logic_vector(4 downto 0);
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
		T0<=('0'&A0)+('0'&B0);
		if T0>9 then Z0<="1010";c1<='1';
			else Z0<="0000";c1<='0';
		end if;
		S0<=std_logic_vector(T0-('0'&Z0))(3 downto 0);
		
		T1<=('0'&A1)+('0'&B1)+c1;
		if(T1>9) then Z1<="1010";c2<='1';
			else Z1<="0000";c2<='0';
		end if;
		S1<=std_logic_vector(T1-('0'&Z1))(3 downto 0);
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
