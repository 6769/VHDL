-- This is a behavioral model of a Mealy state machine (Figure 2-53)
-- based on its state table. The output (Z) and next state are
-- computed before the active edge of the clock. The state change
-- occurs on the rising edge of the clock.

entity Code_Converter is
  port(X, CLK: in bit;
       Z: out bit);
end Code_Converter;

architecture Behavioral of Code_Converter is
signal State, Nextstate: integer range 0 to 6;
begin
  process(State, X)              -- Combinational Circuit
  begin
    case State is
      when 0 =>
        if X = '0' then Z <= '1'; Nextstate <= 1;
        else Z <= '0'; Nextstate <= 2; end if;
      when 1 =>
        if X = '0' then Z <= '1'; Nextstate <= 3;
        else Z <= '0'; Nextstate <= 4; end if;
      when 2 =>
        if X = '0' then Z <= '0'; Nextstate <= 4; 
        else Z <= '1'; Nextstate <= 4; end if;
      when 3 =>
        if X = '0' then Z <= '0'; Nextstate <= 5; 
        else Z <= '1'; Nextstate <= 5; end if;
      when 4 =>
        if X = '0' then Z <= '1'; Nextstate <= 5;
        else Z <= '0'; Nextstate <= 6; end if;
      when 5 =>
        if X = '0' then Z <= '0'; Nextstate <= 0; 
        else Z <= '1'; Nextstate <= 0; end if;
      when 6 =>
        if X = '0' then Z <= '1'; Nextstate <= 0; 
        else Z <= '0'; Nextstate <= 0; end if;
      when others => null;          -- should not occur
    end case;
  end process;

  process(CLK)                      -- State Register
  begin
    if CLK'EVENT and CLK = '1' then -- rising edge of clock
      State <= Nextstate;
    end if;
  end process;
end Behavioral;
