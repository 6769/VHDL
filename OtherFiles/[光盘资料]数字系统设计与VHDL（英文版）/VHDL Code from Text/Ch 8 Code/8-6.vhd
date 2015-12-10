entity hold_Tester is
  port(clk, D: in bit);
end hold_Tester;

architecture internal of hold_Tester is
constant setup_time: time := 2 ns;
constant hold_time: time := 2 ns;
begin
  check: process
  begin
    wait until (Clk'event and CLK = '0');
    assert (D'stable(setup_time))
      report ("Setup time violation")
      severity error;
    wait for hold_time;
    assert (D'stable(hold_time))
      report ("Hold time violation")
      severity error;
  end process check;
end internal;