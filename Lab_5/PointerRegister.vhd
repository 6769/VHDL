entity PointerRegister is
	port(
	Sum:in integer range 2 to 12;
	Sp:in bit;
	LockedSum:out integer range 2 to 12
	);
end entity PointerRegister;
architecture Behave of PointerRegister is
signal recorded:integer range 2 to 12;
begin
	process(Sp,Sum)
	begin
		if(Sp='0')then recorded<=Sum;
		end if ;
	end process;
	LockedSum<=recorded;
end architecture Behave;
