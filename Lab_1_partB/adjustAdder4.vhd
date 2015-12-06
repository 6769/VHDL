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
	