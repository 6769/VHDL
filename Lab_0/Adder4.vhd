--another function is adjust BCD ,like the instruct DA in 8051;
entity Adder4 is 
	port(A,B:in bit_vector (3 downto 0);
			cin:in bit ;
			S:out bit_vector(3 downto 0);
			cout:buffer bit
			);
end Adder4;


architecture Bcd4bit_fullAdder of Adder4 is
	component FullAdder
		port(a,b,cin:in  bit ;
			   s,cout:out bit );
	end component;
	signal C:bit_vector(3 downto 1);--internal carry bit ;
	signal s_mid:bit_vector(3 downto 0);
	signal z,cout_mid:bit;

begin
--	process(A,B,cin)
--	begin
		FA0:FullAdder port map(A(0),B(0),cin ,s_mid(0),C(1));
		FA1:FullAdder port map(A(1),B(1),C(1),s_mid(1),C(2));
		FA2:FullAdder port map(A(2),B(2),C(2),s_mid(2),C(3));
		FA3:FullAdder port map(A(3),B(3),C(3),s_mid(3),cout_mid);
		
--		z<= cout_mid or s_mid(3)or (s_mid(2)and s_mid(1));
--		if z='0' then S<=s_mid;
--					else Adder4 port map (s_mid,"0110",'0',S,cout);
--		end if;
--		cout<=z;	

--	end process;
	S<=s_mid;
end Bcd4bit_fullAdder;
