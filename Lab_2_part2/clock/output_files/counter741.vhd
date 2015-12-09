--741
entity counter741 is
	port(clk :in bit;
		Qout:out unsigned(3 downto 0));
end entity counter741;

architecture neibu of counter741 is
	signal Q:unsigned(3 downto 0);
begin
	Qout<=Q;
	process(clk)
	
	begin
		
	end process;


end architecture neibu;