entity Counter1to6 is
    port(clk,limit:in bit;
    Carry:out bit;
    Count:out integer range 6 downto 1);
end entity Counter1to6;

architecture CountInternal of Counter1to6 is
signal count_value:integer range 6 downto 1;
begin
    Count<=count_value;
    --Carry<='1' when count_value=6
    --else '0';
    process(clk,limit)
	begin
    if(clk'event and clk='1' and limit='1') then 
        if (count_value=6) then count_value<=1;
        else count_value<=count_value+1;
        end if;
        if(count_value=5) then Carry<='1';
        else Carry<='0';
        end if;
    end if;
    end process;
end architecture CountInternal;