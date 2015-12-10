--2 input NAND gate
entity Nand2 is
	port (A1,A2: in bit; Z: out bit);
end Nand2;
architecture concur of Nand2 is
begin
	Z <= not (A1 and A2)after 10 ns;
end;
