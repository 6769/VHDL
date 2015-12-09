--round shift register;
entity rotate_shift_register is
    port(clk,reset: in bit;
		--problem is that the predefined value seems didn't assigned
        hex0:buffer bit_vector(7 downto 0):="10000001";	--O
        hex1:buffer bit_vector(7 downto 0):="10001111";	--L
        hex2:buffer bit_vector(7 downto 0):="10001111";	--L
        hex3:buffer bit_vector(7 downto 0):="00001101";	--E
        hex4:buffer bit_vector(7 downto 0):="00010011";	--H
        hex5:buffer bit_vector(7 downto 0):="11111111";	--nothing
        hex6:buffer bit_vector(7 downto 0):="11111111";	--
        hex7:buffer bit_vector(7 downto 0):="11111111"	--nothing        
        );
end entity rotate_shift_register;

architecture realize of rotate_shift_register is
	
begin
	
	process(reset,clk)
	begin
		if reset='0' then
		hex0<="10000001";	--O
        hex1<="10001111";	--L
        hex2<="10001111";	--L
        hex3<="00001101";	--E
        hex4<="00010011";	--H
        hex5<="11111111";	--nothing
        hex6<="11111111";	--
        hex7<="11111111";	--nothing
		elsif clk'event and clk='1' then 
		hex0<=hex7;
		hex1<=hex0;
		hex2<=hex1;
		hex3<=hex2;
		hex4<=hex3;
		hex5<=hex4;
		hex6<=hex5;
		hex7<=hex6;
		end if;
	end process;
end architecture realize;