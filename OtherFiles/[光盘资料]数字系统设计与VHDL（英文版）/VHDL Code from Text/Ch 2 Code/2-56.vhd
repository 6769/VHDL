-- This is a behavioral model of the Mealy state machine for BCD to
-- Excess-3 Code Converter based on its state table. The state change
-- occurs on the rising edge of the clock. The output is computed by a
-- conditional assignment statement whenever State or Z changes.

entity Code_Converter2 is
  port(X, CLK: in bit;
       Z: out bit);
end Code_Converter2;

architecture one_process of Code_Converter2 is
signal State: integer range 0 to 6 := 0;
begin
  process(CLK)
  begin
    if CLK'event and CLK = '1' then
      case State is
        when 0 =>
          if X = '0' then State <= 1; else State <= 2; end if;
        when 1 =>
          if X = '0' then State <= 3; else State <= 4; end if;
        when 2 =>
          State <= 4;
        when 3 =>
          State <= 5;
        when 4 =>
          if X = '0' then State <= 5; else State <= 6; end if;
        when 5 =>
          State <= 0;
        when 6 =>
          State <= 0;
      end case;
    end if;
  end process;
  Z <= '1' when (State = 0 and X = '0') or (State = 1 and X = '0')
             or (State = 2 and X = '1') or (State = 3 and X = '1')
             or (State = 4 and X = '0') or (State = 5 and X = '1')
             or State = 6
       else '0';
end one_process;
