entity GameTest is
  port(Rb, Reset: out bit;
       Sum: out integer range 2 to 12;
       CLK: inout bit;
       Roll, Win, Lose: in bit);
end GameTest;

architecture dicetest of GameTest is
signal Tstate, Tnext: integer range 0 to 3;
signal Trig1: bit;
type arr is array(0 to 11) of integer;
constant Sumarray:arr := (7, 11, 2, 4, 7, 5, 6, 7, 6, 8, 9, 6);
begin
  CLK <= not CLK after 20 ns;
  process(Roll, Win, Lose, Tstate)
  variable i: natural;                       -- i is initialized to 0
  begin
    case Tstate is
      when 0 => Rb <= '1';                   -- wait for Roll
        Reset <= '0';
        if i >= 12 then Tnext <= 3;
        elsif Roll = '1' then
          Sum <= Sumarray(i);
          i := i + 1;
          Tnext <= 1;
        end if;
      when 1 => Rb <= '0'; Tnext <= 2;
      when 2 => Tnext <= 0;
        Trig1 <= not Trig1;                  -- toggle Trig1
        if (Win or Lose) = '1' then
          Reset <= '1';
        end if;
      when 3 => null;                        -- Stop state
    end case;
  end process;

  process(CLK)
  begin
    if CLK = '1' and CLK'event then
      Tstate <= Tnext;
    end if;
  end process;
end dicetest;
