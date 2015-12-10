entity NAND2 is
  generic(Trise, Tfall: time; load: natural);
  port(a, b: in bit;
       c: out bit);
end NAND2;

architecture behavior of NAND2 is
signal nand_value: bit;
begin
  nand_value <= a nand b;
  c <= nand_value after (Trise + 3 ns * load) when nand_value = '1'
    else nand_value after (Tfall + 2 ns * load);
end behavior;

entity NAND2_test is
  port(in1, in2, in3, in4: in bit;
       out1, out2: out bit);
end NAND2_test;

architecture behavior of NAND2_test is
component NAND2 is
  generic(Trise: time := 3 ns; Tfall: time := 2 ns; load: natural := 1);
  port(a, b: in bit;
       c: out bit);
end component;
begin
  U1: NAND2 generic map (2 ns, 1 ns, 2) port map (in1, in2, out1);
  U2: NAND2 port map (in3, in4, out2);
end behavior;
