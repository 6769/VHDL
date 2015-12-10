entity BILBO is               -- BILBO Register
  generic (NBITS: natural range 4 to 8 := 4);
  port (Clk, CE, B1, B2, Si: in bit;
        So: out bit;
        Z: in bit_vector(1 to NBITS);
        Q: inout bit_vector(1 to NBITS));
end BILBO;

architecture behavior of BILBO is
  signal FB: bit;
begin
  Gen8: if NBITS = 8 generate
    FB <= Q(2) xor Q(3) xor Q(NBITS); end generate;
  Gen5: if NBITS = 5 generate
    FB <= Q(2) xor Q(NBITS); end generate;
  GenX: if not(NBITS = 5 or NBITS = 8) generate
    FB <= Q(1) xor Q(NBITS); end generate;
  process(Clk)
    variable mode: bit_vector(1 downto 0);
  begin
    if (Clk = '1' and CE = '1') then
      mode := B1 & B2;
      case mode is
      when "00" =>     -- Shift register mode
        Q <= Si & Q(1 to NBITS-1);
      when "01" =>     -- Pseudo Random Pattern Generator mode
        Q <= FB & Q(1 to NBITS-1);
      when "10" =>     -- Normal Operating mode
        Q <= Z;
      when "11" =>     -- Multiple Input Signature Register mode
        Q <= Z(1 to NBITS) xor (FB & Q(1 to NBITS-1));
      end case;
    end if;
  end process;
  So <= Q(NBITS);
end;