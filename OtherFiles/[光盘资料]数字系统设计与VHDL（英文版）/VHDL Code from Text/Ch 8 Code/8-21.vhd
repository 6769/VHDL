entity shift_reg is
  generic(N: positive := 4; Lshift: Boolean := true);-- generic parameters used
  port(D: in bit_vector(N downto 1);                 -- named association
       Qout: out bit_vector(N downto 1);
       CLK, Ld, Sh, Shiftin: in bit);
end shift_reg;

architecture SRN of shift_reg is
signal Q, shifter: bit_vector(N downto 1);
begin
  Qout <= Q;
  genLS: if Lshift generate     -- conditional generate of left shift register
    shifter <= Q(N-1 downto 1) & Shiftin;
  end generate;
  genRS: if not Lshift generate -- conditional generate of right shift register
    shifter <= Shiftin & Q(N downto 2);
  end generate;
  process(CLK)
  begin
    if CLK'event and CLK = '1' then
      if LD = '1' then Q <= D;
      elsif Sh = '1' then Q <= shifter;
      end if;
    end if;
  end process;
end SRN;

entity shifttest is
  port(clk, ld1, sh1, shiftin1, ld2, sh2, shiftin2: in bit;
       in1: in bit_vector(4 downto 1); in2: in bit_vector(6 downto 1);
       out1: out bit_vector(4 downto 1); out2: out bit_vector(6 downto 1));
end shifttest;

architecture logic of shifttest is
  component shift_reg is
  generic(N: positive := 4; Lshift: Boolean := true);
  port(D: in bit_vector(N downto 1);
       Qout: out bit_vector(N downto 1);
       CLK, Ld, Sh, Shiftin: in bit);
end component;
begin
  shiftL: shift_reg port map (in1, out1, clk, ld1, sh1, shiftin1);
  shiftR: shift_reg generic map (6, false) port map (in2, out2, clk, ld2, sh2, shiftin2);
end logic;