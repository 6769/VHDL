
--------------------------------------------------------------
 ------------------------------------------------------------
  --                clock_signal_per_second.vhd
 ------------------------------------------------------------
--------------------------------------------------------------

library ieee;
use ieee.numeric_bit.all;

entity clock_signal_per_second is
    port(clk:in bit;
	second_output:buffer bit);

end entity clock_signal_per_second;

architecture behavior of clock_signal_per_second is
signal counter_for_osc_signal:unsigned(31 downto 0);
constant Terminator:integer:=25000000;--25*1000*1000
begin
    process
    begin
        wait until clk'event and clk='1';
        if counter_for_osc_signal<Terminator then counter_for_osc_signal<=counter_for_osc_signal+1;
        else counter_for_osc_signal<=(others=>'0');
            second_output<=not second_output;
        end if;
    end process;

end architecture behavior;

--------------------------------------------------------------
 ------------------------------------------------------------
  --                H24_Min60_Sec60.vhd
 ------------------------------------------------------------
--------------------------------------------------------------

 library ieee;
 use ieee.numeric_bit.all;
 
entity H24_Min60_Sec60 is
    port(Clk,Ldn:in bit;
        Din :in  unsigned(16 downto 1);
        Qout:out unsigned(23 downto 0));
end entity H24_Min60_Sec60;

architecture Behavior of H24_Min60_Sec60 is
    signal Q:unsigned(23 downto 0);
    alias Second_low:unsigned(3 downto 0) is Q(3 downto 0);
    alias Second_hig:unsigned(3 downto 0) is Q(7 downto 4);
    alias Min_low:   unsigned(3 downto 0) is Q(11 downto 8);
    alias Min_hig:   unsigned(3 downto 0) is Q(15 downto 12);
    alias Hour_low:  unsigned(3 downto 0) is Q(19 downto 16);
    alias Hour_hig:  unsigned(3 downto 0) is Q(23 downto 20);
    
    --internal logic
    signal second_count,min_count:integer range 0 to 59;--(63 downto 0);
    signal hour_count:            integer range 0 to 23;--(31 downto 0);
    --signal carry_from_second,carry_from_min:bit;
begin
    Qout<=Q;
    process(Clk,Ldn,Din)
    begin
        if(Ldn='0') then min_count<=to_integer(Din(6 downto 1));hour_count<=to_integer(Din(13 downto 9));
        elsif(Clk'event and Clk='1') then 
            if(second_count=59) then second_count<=0;
                if(min_count=59)    then min_count<=0;
                    if(hour_count=23)   then hour_count<=0;
                    else hour_count<=hour_count+1;
                    end if;
                --carry_from_min<='1';
                else min_count<=min_count+1;
                end if;
            --carry_from_second<='1';
            else second_count<=second_count+1;
            end if;
            
            
        end if;
    end process;
    Second_low<=to_unsigned(second_count mod 10,4);
    Second_hig<=to_unsigned(second_count/10,4);
    Min_low<=to_unsigned(min_count mod 10,4);
    Min_hig<=to_unsigned(min_count/10,4);
    Hour_low<=to_unsigned(hour_count mod 10,4);
    Hour_hig<=to_unsigned(hour_count/10,4);
end architecture Behavior;

--------------------------------------------------------------
 ------------------------------------------------------------
  --                H24_Min60_Sec60_v2.vhd
 ------------------------------------------------------------
--------------------------------------------------------------

library ieee;
use ieee.numeric_bit.all;
 
entity H24_Min60_Sec60_v2 is
    port(Clk,Ldn,Reset:in bit;
        Din :in  unsigned(15 downto 0);
        Qout:out unsigned(23 downto 0));
end entity H24_Min60_Sec60_v2;

architecture Behavior of H24_Min60_Sec60_v2 is
    signal Q:unsigned(23 downto 0);
    alias Second_low:unsigned(3 downto 0) is Q(3 downto 0);
    alias Second_hig:unsigned(3 downto 0) is Q(7 downto 4);
    alias Min_low:   unsigned(3 downto 0) is Q(11 downto 8);
    alias Min_hig:   unsigned(3 downto 0) is Q(15 downto 12);
    alias Hour_low:  unsigned(3 downto 0) is Q(19 downto 16);
    alias Hour_hig:  unsigned(3 downto 0) is Q(23 downto 20);
    
    --internal logic
    -- signal second_count,min_count:integer range 0 to 59;--(63 downto 0);
    -- signal hour_count:            integer range 0 to 23;--(31 downto 0);
    --signal carry_from_second,carry_from_min:bit;
    constant CLs:unsigned(3 downto 0):="0000";
begin
    Qout<=Q;
    process(Clk,Ldn,Reset)
    begin
        if(Reset='0') then --min_count<=to_integer(Din(6 downto 1));hour_count<=to_integer(Din(13 downto 9));
--            Min_low <=Din(4 downto 1);
--            Min_hig <=Din(8 downto 5);
--            Hour_low<=Din(12 downto 9);
--            Hour_hig<=Din(16 downto 13);
			Q<=(others=>'0');
		elsif(Ldn='0' and Reset='1') then Q(23 downto 8)<=Din;
        elsif(Clk'event and Clk='1') then 
            if(Second_low=9) then Second_low<=CLs;
                if(Second_hig=5) then Second_hig<=CLs;
                    if(Min_low=9) then Min_low<=CLs;
                        if(Min_hig=5) then Min_hig<=CLs;
                            if(Hour_hig<2)then 
                                if(Hour_low=9) then Hour_low<=CLs;Hour_hig<=Hour_hig+1;
                                else Hour_low<=Hour_low+1;
                                end if;
                            else --Hour_hig==2
                                if(Hour_low=3) then Hour_low<=CLs;Hour_hig<=CLs;
                                else Hour_low<=Hour_low+1;
								end if;
                            end if;
                        else Min_hig<=Min_hig+1;
                        end if;
                    else Min_low<=Min_low+1;
                    end if;
                else Second_hig<=Second_hig+1;
                end if;
            else Second_low<=Second_low+1;
            end if;
            
            -------------------------------------------old design,too much latchs...--------------------------
            -- if(second_count=59) then second_count<=0;
                -- if(min_count=59)    then min_count<=0;
                    -- if(hour_count=23)   then hour_count<=0;
                    -- else hour_count<=hour_count+1;
                    -- end if;
                -- --carry_from_min<='1';
                -- else min_count<=min_count+1;
                -- end if;
            -- --carry_from_second<='1';
            -- else second_count<=second_count+1;
            -- end if;
            
            
        end if;
    end process;
    -- Second_low<=to_unsigned(second_count mod 10,4);
    -- Second_hig<=to_unsigned(second_count/10,4);
    -- Min_low<=to_unsigned(min_count mod 10,4);
    -- Min_hig<=to_unsigned(min_count/10,4);
    -- Hour_low<=to_unsigned(hour_count mod 10,4);
    -- Hour_hig<=to_unsigned(hour_count/10,4);
end architecture Behavior;

--------------------------------------------------------------
 ------------------------------------------------------------
  --                Segment7Decoder.vhd
 ------------------------------------------------------------
--------------------------------------------------------------

library IEEE;
use ieee.numeric_bit.all;

entity Segment7Decoder is
	port (bcd	: in unsigned(3 downto 0);  --BCD input
        segment7 : out unsigned(6 downto 0)  -- 7 bit decoded output.
    );
end Segment7Decoder;
--'a' corresponds to MSB of segment7 and g corresponds to LSB of segment7.
architecture Behavioral of Segment7Decoder is

begin
process (bcd)
BEGIN

	case  bcd is
			when "0000"=> segment7 <="1000000";  -- '0'
			when "0001"=> segment7 <="1111001";  -- '1'
			when "0010"=> segment7 <="0100100";  -- '2'
			when "0011"=> segment7 <="0110000";  -- '3'
			when "0100"=> segment7 <="0011001";  -- '4' 
			when "0101"=> segment7 <="0010010";  -- '5'
			when "0110"=> segment7 <="0000010";  -- '6'
			when "0111"=> segment7 <="1111000";  -- '7'
			when "1000"=> segment7 <="0000000";  -- '8'
			when "1001"=> segment7 <="0010000";  -- '9'
            when "1010"=> segment7 <="0001000"; --'A'
            when "1011"=> segment7 <="0000011"; --'b'
            when "1100"=> segment7 <="0100111"; --'c'
            when "1101"=> segment7 <="0100001"; --'d'
            when "1110"=> segment7 <="0000110"; --'E'
            when "1111"=> segment7 <="0001110"; --'f'
			 --nothing is displayed when a number more than 9 is given as input. 
			when others=> segment7 <="1111111"; 
	end case;
end process;

end Behavioral;

--------------------------------------------------------------
 ------------------------------------------------------------
  --                View.vhd
 ------------------------------------------------------------
--------------------------------------------------------------

library ieee;
use ieee.numeric_bit.all;

entity View is
	port(Clk_original,Reset,Ldn:in bit;
		Din:in unsigned(15 downto 0);
		hex0,hex1,hex2,hex3,hex4,hex5:out unsigned(7 downto 0));
end entity View;

architecture Behave of View is

component clock_signal_per_second is
    port(clk:in bit;
	second_output:buffer bit);
end component;
component Segment7Decoder is
	port (bcd	: in unsigned(3 downto 0);  --BCD input
        segment7 : out unsigned(6 downto 0)  -- 7 bit decoded output.
    );
end component;
component H24_Min60_Sec60_v2 is
    port(Clk,Ldn,Reset:in bit;
        Din :in  unsigned(15 downto 0);
        Qout:out unsigned(23 downto 0));
end component;
signal mid_second:bit;
signal Q:unsigned(23 downto 0);
	alias Second_low:unsigned(3 downto 0) is Q(3 downto 0);
    alias Second_hig:unsigned(3 downto 0) is Q(7 downto 4);
    alias Min_low:   unsigned(3 downto 0) is Q(11 downto 8);
    alias Min_hig:   unsigned(3 downto 0) is Q(15 downto 12);
    alias Hour_low:  unsigned(3 downto 0) is Q(19 downto 16);
    alias Hour_hig:  unsigned(3 downto 0) is Q(23 downto 20);
begin
	hex0(0)<='1';
	hex1(0)<='1';
	hex2(0)<='1';
	hex3(0)<='1';
	hex4(0)<='1';
	hex5(0)<='1';
	High50Mhz:clock_signal_per_second port map(Clk_original,mid_second);
	Core:H24_Min60_Sec60_v2 port map(mid_second,Ldn,Reset,Din,Q);
	Hex0_display:Segment7Decoder port map(Second_low,hex0(7 downto 1));
	Hex1_display:Segment7Decoder port map(Second_hig,hex1(7 downto 1));
	Hex2_display:Segment7Decoder port map(Min_low,  hex2(7 downto 1));
	Hex3_display:Segment7Decoder port map(Min_hig,hex3(7 downto 1));
	Hex4_display:Segment7Decoder port map(Hour_low,hex4(7 downto 1));
	Hex5_display:Segment7Decoder port map(Hour_hig,hex5(7 downto 1));
end architecture Behave;


