entity dummy is
end dummy;

architecture var of dummy is 
signal trigger, sum: integer:=0;
begin
  process
  variable var1: integer:=1;
  variable var2: integer:=2;
  variable var3: integer:=3;
  begin
    wait on trigger;
    var1 := var2 + var3;
    var2 := var1;
    var3 := var2;
    sum <= var1 + var2 + var3;
  end process;
end var;
