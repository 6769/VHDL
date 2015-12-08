entity T_flip_flop is 
	port(T,clk,clear:in bit;
		Q,QN:buffer bit
		);
end T_flip_flop;

architecture internal of T_flip_flop is
begin
	QN<=not Q;
	
	process(clk,clear)
	begin	
		if(clear='0') then Q<='0';
			elsif(clk'event and clk='1') then
				if T='1' then Q<= QN;
				end if;
		end if ;

	end process;	
end architecture internal;