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