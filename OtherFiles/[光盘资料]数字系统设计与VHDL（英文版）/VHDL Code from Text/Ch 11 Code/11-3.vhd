library IEEE;
use IEEE.numeric_bit.all;

entity wristwatch is
  port(B1, B2, B3, clk: in bit;
       am_pm, aam_pm, ring, alarm_set: inout bit;
       hours, ahours, minutes, aminutes, seconds: inout unsigned(7 downto 0);
       swhundreths, swseconds, swminutes: out unsigned(7 downto 0));
end wristwatch;

architecture wristwatch1 of wristwatch is
  component clock is
    port(clk, inch, incm, incha, incma, set_alarm, alarm_off: in bit;
         hours, ahours, minutes, aminutes, seconds: inout unsigned(7 downto 0);
         am_pm, aam_pm, ring, alarm_set: inout bit);
  end component;
  component stopwatch is
    port(clk, reset, start_stop: in bit;
         swhundreths, swseconds, swminutes: out unsigned(7 downto 0));
  end component;
  type st_type is (time1, set_min, set_hours, alarm, set_alarm_hrs,
                   set_alarm_min, stop_watch);
  signal state, nextstate: st_type;
  signal inch, incm, alarm_off, set_alarm, incha, incma,
         start_stop, reset: bit;
begin
  clock1: clock port map(clk, inch, incm, incha, incma, set_alarm, alarm_off,
                         hours, ahours, minutes, aminutes, seconds, am_pm,
                         aam_pm, ring, alarm_set);
  stopwatch1: stopwatch port map(clk, reset, start_stop, swhundreths,
                                 swseconds, swminutes);
  process(state, B1, B2, B3)
  begin
    alarm_off <= '0'; inch <= '0'; incm <= '0'; set_alarm <= '0'; incha <= '0';
    incma <= '0'; start_stop <= '0'; reset <= '0';
    case state is
      when time1 =>
        if B1 = '1' then nextstate <= alarm;
        elsif B2 = '1' then nextstate <= set_hours;
        else nextstate <= time1;
        end if;
        if B3 = '1' then alarm_off <= '1';
        end if;
     when set_hours =>
        if B3 = '1' then inch <= '1'; nextstate <= set_hours;
        else nextstate <= set_hours;
        end if;
        if B2 = '1' then nextstate <= set_min;
        end if;
     when set_min =>
        if B3 = '1' then incm <= '1'; nextstate <= set_min;
        else nextstate <= set_min;
        end if;
        if B2 = '1' then nextstate <= time1;
        end if;
     when alarm =>
        if B1 = '1' then nextstate <= stop_watch;
        elsif B2 = '1' then nextstate <= set_alarm_hrs;
        else nextstate <= alarm;
        end if;
        if B3 = '1' then set_alarm <= '1'; nextstate <= alarm;
        end if;
     when set_alarm_hrs =>
        if B2 = '1' then nextstate <= set_alarm_min;
        else nextstate <= set_alarm_hrs;
        end if;
        if B3 = '1' then incha <= '1';
        end if;
     when set_alarm_min =>
        if B2 = '1' then nextstate <= alarm;
        else nextstate <= set_alarm_min;
        end if;
        if B3 = '1' then incma <= '1';
        end if;
     when stop_watch =>
        if B1 = '1' then nextstate <= time1;
        else nextstate <= stop_watch;
        end if;
        if B2 = '1' then start_stop <= '1';
        end if;
        if B3 = '1' then reset <= '1';
        end if;
    end case;
  end process;
  process(clk)
  begin
    if clk'event and clk = '1' then
      state <= nextstate;
    end if;
  end process;
end wristwatch1;
