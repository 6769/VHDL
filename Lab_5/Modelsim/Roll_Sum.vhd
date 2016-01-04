entity Roll_Sum is 
    port(Rb,CLK,Reset:in bit;
    hex0,hex1:out integer range 6 downto 1;
    Sum:out integer range 12 downto 2
    );
end entity Roll_Sum;

architecture Behavior of Roll_Sum is
signal count0,count1:integer range 6 downto 1:=1;
signal Run:bit;
begin
    Run<=Rb and CLK;
    hex0<=count0;
    hex1<=count1;
    Sum<=count0+count1;
    process(Run,Reset)
    begin
        if(Reset='1')then count0<=1;count1<=1;
        elsif(Run'event and Run='1')then
            if(count0=6)then count0<=1;
                if(count1=6)then count1<=1;
                else count1<=count1+1;
                end if;
            else count0<=count0+1;
          end if;
        end if;
    end process;
end architecture Behavior;
