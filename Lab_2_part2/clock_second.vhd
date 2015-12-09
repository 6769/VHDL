--Intertime clock
entity clock_second is
	port(clk50Mhz:in bit ;
		second:buffer bit);
end entity clock_second;

architecture Distribution of clock_second is


begin
	process
	variable counter_for_osc:integer:=0;
	begin
		wait until clk50Mhz'event and clk50Mhz='1';
		
		if counter_for_osc < 50*1000*1000 and counter_for_osc>25*1000*1000 then
			second<='1';
			counter_for_osc:=counter_for_osc+1;
		elsif counter_for_osc>25*1000*1000 then 
			second<='0';
			counter_for_osc:=counter_for_osc+1;
		elsif counter_for_osc=50*1000*1000 then
			counter_for_osc:=0;
		end if;
	end process;
end architecture Distribution;