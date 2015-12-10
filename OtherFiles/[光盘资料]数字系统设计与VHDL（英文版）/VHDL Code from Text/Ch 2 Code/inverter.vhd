entity Inverter is
	port (A: in bit; Z: out bit);
end Inverter;
architecture concur of Inverter is
begin
	Z <= not A after 10 ns;
end concur;
