--another function is adjust BCD ,like the instruct DA in 8051;
entity Adder4 is 
	port(A,B:in bit_vector (3 downto 0);
			cin:in bit ;
			s:out bit_vector(3 downto 0);
			cout:out bit
			);
end Adder4


architecture Bcd4bit_fullAdder of Adder4 is
	component FullAdder
		port(a,b,cin:in  bit ;
			s,cout:out bit );
	end component;

