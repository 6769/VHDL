entity Counter16anDisplay is
    port(clk,enable,clear:in bit;
        hex0,hex1,hex2,hex3:out bit_vector(7 downto 0)
    );
end entity Counter16anDisplay;

architecture combination of Counter16anDisplay is
    component NbitCounter
        port(
        clear:in bit:='1';
        clk,enable:in bit ;
        Q:buffer bit_vector(15 downto 0):=( others=>'0')   );
        --Q:buffer bit_vector(15 downto 0):="1111111111111100");
    end component;
    component Segment7Decoder is
        port (bcd	: in bit_vector(3 downto 0);  --BCD input
            segment7 : out bit_vector(6 downto 0)  -- 7 bit decoded output.
        );
    end component;
    signal midQ:bit_vector(15 downto 0);
begin 
    hex0(0)<='1';
    hex1(0)<='1';
    hex2(0)<='1';
    hex3(0)<='1';
    
    counter_part:NbitCounter port map(clear,clk,enable,midQ);
    displayLED0:segment7Decoder port map(midQ(3 downto  0),hex0 (7 downto 1));
    displayLED1:segment7Decoder port map(midQ(7 downto  4),hex1 (7 downto 1));
    displayLED2:segment7Decoder port map(midQ(11 downto 8),hex2 (7 downto 1));
    displayLED3:segment7Decoder port map(midQ(15 downto 12),hex3(7 downto 1));
    
end architecture combination;