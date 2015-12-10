library IEEE;
use IEEE.numeric_bit.all;

entity testww is   -- test bench for wristwatch
  port(hours, ahours, minutes, aminutes, seconds,
       swhundreths, swseconds, swminutes: inout unsigned(7 downto 0);
       am_pm, aam_pm, ring, alarm_set: inout bit);
end testww;

architecture testww1 of testww is
  component wristwatch is
    port(B1, B2, B3, clk: in bit;
         am_pm, aam_pm, ring, alarm_set: inout bit;
         hours, ahours, minutes, aminutes, seconds: inout unsigned(7 downto 0);
         swhundreths, swseconds, swminutes: out unsigned(7 downto 0));
  end component;
  signal B1, B2, B3, clk: bit;
begin
  wristwatch1: wristwatch port map(B1, B2, B3, clk, am_pm, aam_pm, ring,
                                   alarm_set, hours, ahours, minutes, aminutes,
                                   seconds, swhundreths, swseconds, swminutes);
  clk <= not clk after 5 ms;   -- generate 100hz clock
  process is
  procedure wait1   -- waits for N1 clocks
    (N1: in integer) is
    variable count: integer;
  begin
    count := N1;
    while count /= 0 loop
      wait until clk'event and clk = '1';
      count := count - 1;
      wait until clk'event and clk = '0';
    end loop;
  end procedure wait1;
  procedure push   -- simulates pushing a button N times
    (signal button: out bit; N: in integer) is
  begin
    for i in 1 to N loop
      button <= '1';
      wait1(1);
      button <= '0';
      wait1(120);   -- wait 1200 ms between pushes
    end loop;
  end procedure push;
  begin
    wait1(10);   -- set time to 11:58 pm
    push(b2, 1); push(b3, 23); push(b2, 1); push(b3, 57); push(b2, 1);
    report "time should be 11:58 P.M.";
    push(b1, 1);   -- set alarm to 12:00 am
    push(b2, 1); push(b3, 24); push(b2, 2); push(b3, 1); push(b1, 2);
    report "alarm should be set to 12:00 A.M.";
    wait until hours = "00010010" and seconds = "00000101";
    push(b3, 1);   -- turn alarm off at 12 hours and 5 seconds
    --wait until ring = '0';
    --report "alarm should turn off now";
    push(b1, 2);   -- run stopwatch, go to time mode, go back to stopwatch
    push(b2, 1); wait1(120); push(b1, 1); wait1(1000); push(b1, 2);
    wait until swminutes = "00000001" and swseconds = "00000010";
      --stop stopwatch after 1 min. and 2 sec., then reset
    report "stopwatch should read 1 min. 2 sec.";
    push(b2, 1); push(b3, 1); push(b1, 1);
    wait;
  end process;
end testww1;
