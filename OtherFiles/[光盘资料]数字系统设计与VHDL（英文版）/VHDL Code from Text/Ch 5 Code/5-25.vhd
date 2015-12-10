entity DiceGame is 
  port(Rb, Reset, CLK: in bit;
       Sum: in integer range 2 to 12;
       Roll, Win, Lose: out bit);
end DiceGame;

architecture Dice_Eq of DiceGame is
signal Sp,Eq,D7,D711,D2312: bit:='0';
signal DA,DB,DC,A,B,C :bit:='0';
signal Point: integer range 2 to 12;
begin
  process(CLK)
  begin
    if CLK = '1' and CLK'event then
      A <= DA; B <= DB; C <= DC;
      if Sp = '1' then Point <= Sum; end if;
    end if;
  end process;
  Win <= B and not C;
  Lose <= B and C;
  Roll <= not B and C and Rb;
  Sp <= not A and not B and C and not Rb and not D711 and not D2312;
  D7 <= '1' when Sum = 7 else '0';
  D711 <= '1' when (Sum = 11) or (Sum = 7) else '0';
  D2312 <= '1' when (Sum = 2) or (Sum = 3) or (Sum = 12) else '0';
  Eq <= '1' when Point=Sum else '0';
  DA <= (not A and not B and C and not Rb and not D711 and not D2312) or
        (A and not C) or (A and Rb) or (A and not D7 and not Eq);
  DB <= ((not A and not B and C and not Rb) and (D711 or D2312)) or
        (B and not Reset) or ((A and C and not Rb) and (Eq or D7));
  DC <= (not B and Rb) or (not A and not B and C and not D711 and D2312) or
        (B and C and not Reset) or (A and C and D7 and not Eq);
end Dice_Eq;
