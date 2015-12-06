--------------------------------------------------------
---------------------partB------------------------------
--------------------------------------------------------
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