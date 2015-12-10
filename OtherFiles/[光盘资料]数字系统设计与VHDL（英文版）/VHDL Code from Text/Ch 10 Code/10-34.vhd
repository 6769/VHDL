entity BILBO_System is
  port (Clk, LdA, LdB, LdC, B1, B2, Si: in bit;
        So: out bit;
        DBus: in bit_vector(3 downto 0);
        Output: inout bit_vector(4 downto 0));
end BILBO_System;

architecture BSys1 of BILBO_System is
  component Adder4 is
    port (A, B: in bit_vector(3 downto 0); Ci: in bit;
          S: out bit_vector(3 downto 0); Co:out bit);
  end component;
  component BILBO is
    generic (NBITS: natural range 4 to 8 := 4);
    port (Clk, CE, B1, B2, Si : in bit;
          So: out bit;
          Z: in bit_vector(1 to NBITS);
          Q: inout bit_vector(1 to NBITS));
  end component;

  signal Aout, Bout: bit_vector(3 downto 0);
  signal Cin: bit_vector(4 downto 0);
  alias Carry: bit is Cin(4);
  alias Sum: bit_vector(3 downto 0) is Cin(3 downto 0);
  signal ACE, BCE, CCE, CB1, Test, S1, S2: bit;
begin
  Test <= not B1 or B2;
  ACE <= Test or LdA;
  BCE <= Test or LdB;
  CCE <= Test or LdC;
  CB1 <= B1 xor B2;
  RegA: BILBO generic map (4) port map(Clk, ACE, B1, B2, S1, S2, DBus, 					Aout);
  RegB: BILBO generic map (4) port map(Clk, BCE, B1, B2, Si, S1, DBus, 					Bout);
  RegC: BILBO generic map (5) port map(Clk, CCE, CB1, B2, S2, So, Cin, 					Output);
  Adder: Adder4 port map(Aout, Bout, '0', Sum, Carry);
end BSys1;
