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
