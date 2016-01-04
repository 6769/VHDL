entity Compartor is 
	port(
	Sum,LockedSum:in integer range 2 to 12;
	Eq,D7,D711,D2312:out bit
	);
end entity Compartor;
architecture Behavior of Compartor is
begin
	
	Eq<='1' when Sum=LockedSum  else '0';
	D7<='1' when Sum=7 else '0';
	D711<='1' when Sum=7 or Sum=11 else '0';
	D2312<='1' when Sum=2 or Sum=3 or Sum=12 else '0';
	

end architecture Behavior;
	