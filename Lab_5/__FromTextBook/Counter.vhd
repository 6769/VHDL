entity Counter is
  port(Clk, Roll: in bit;
       Sum: out integer range 2 to 12);
end Counter;

architecture Count of Counter is
signal Cnt1, Cnt2: integer range 1 to 6 := 1;
begin
  process(Clk)
  begin
    if Clk = '1' then
      if Roll = '1' then
        if Cnt1 = 6 then Cnt1 <= 1; else Cnt1 <= Cnt1 + 1; end if;
        if Cnt1 = 6 then
          if Cnt2 = 6 then Cnt2 <= 1; else Cnt2 <= Cnt2 + 1; end if;
        end if;
      end if;
    end if;
  end process;
  Sum <= Cnt1 + Cnt2;
end Count;
