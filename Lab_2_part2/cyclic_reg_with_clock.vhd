entity cyclic_reg_with_clock is
	port(clk,reset:in bit;
		hex0,hex1,hex2,hex3,hex4,hex5,hex6,hex7:out bit_vector(7 downto 0)
		);
end entity cyclic_reg_with_clock;

architecture combine of cyclic_reg_with_clock is

component clock_second is
port(clk:in bit ;
		second:buffer bit);
end component;
	component rotate_shift_register 
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
	end component;
	signal midline:bit;
begin
	clock0:clock_second port map(clk,midline);
	reg0:rotate_shift_register port map(midline,reset,hex0,hex1,hex2,hex3,hex4,hex5,hex6,hex7);

end architecture combine;