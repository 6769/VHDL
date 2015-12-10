-- The following is a description of the sequential machine of
-- the BCD to Excess-3 code converter in terms of its next state
-- equations. The following state assignment was used:
-- S0-->0; S1-->4; S2-->5; S3-->7; S4-->6; S5-->3; S6-->2

entity Code_Converter3 is
  port(X, CLK: in bit;
       Z: out bit);
end Code_Converter3;

architecture Equations of Code_Converter3 is
signal Q1, Q2, Q3: bit;
begin
  process(CLK)
  begin
    if CLK='1' and CLK'event then      -- rising edge of clock
      Q1 <= not Q2 after 10 ns;
      Q2 <= Q1 after 10 ns;
      Q3 <= (Q1 and Q2 and Q3) or (not X and Q1 and not Q3) or
            (X and not Q1 and not Q2) after 10 ns;
    end if;
  end process;
  Z <= ((not X) and (not Q3)) or (X and Q3) after 20 ns;
end Equations;
