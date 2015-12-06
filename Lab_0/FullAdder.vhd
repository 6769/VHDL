entity FullAdder is
	port(a,b,cin:in  bit ;
			s,cout:out bit 
	);
end FullAdder;

architecture Equation of FullAdder is
begin
	s   <=a xor b xor cin ;
	cout<=(a and b)or (a and cin )or (b and cin );
end Equation;
