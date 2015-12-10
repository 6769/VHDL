--3 input NAND gate
entity Nand3 is
	port (A1,A2,A3: in bit;	Z: out bit);
end Nand3;
architecture concur of Nand3 is
begin
	Z <= not (A1 and A2 and A3)after 10 ns;
end concur;

