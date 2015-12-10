entity dummy3 is
end dummy3;

architecture var of dummy3 is
signal trigger, sum: integer:=0;
begin
  process(trigger)
  variable var1: integer:=1;
  variable var2: integer:=2;
  variable var3: integer:=3;
  begin
    var1 := var2 + var3;
    var2 := var1;
    var3 := var2;
    sum <= var1 + var2 + var3;
  end process;
end var;
