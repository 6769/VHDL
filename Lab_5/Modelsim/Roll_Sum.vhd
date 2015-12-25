entity Roll_Sum is 
    port(Rb,CLK,Reset:in bit;
    hex0,hex1:out integer range 6 downto 1;
    Sum:out integer range 12 downto 2
    );