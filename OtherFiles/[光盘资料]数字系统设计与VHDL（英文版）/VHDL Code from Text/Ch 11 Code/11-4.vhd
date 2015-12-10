library IEEE;
use IEEE.numeric_bit.all;

entity clock is
  port(clk, inch, incm, incha, incma, set_alarm, alarm_off: in bit;
       hours, ahours, minutes, aminutes, seconds: inout unsigned(7 downto 0);
       am_pm, aam_pm, ring, alarm_set: inout bit);
end clock;

architecture clock1 of clock is
  component CTR_59 is
    port(clk, inc, reset: in bit; dout: out unsigned(7 downto 0); t59: out bit);
  end component;
  component CTR_12 is
    port(clk, inc: in bit; dout: out unsigned(7 downto 0); am_pm: inout bit);
  end component;
  signal s59, m59, inchr, incmin, c99: bit;
  signal alarm_ring_time: integer range 0 to 50;
  signal div100: integer range 0 to 99;
  begin
    sec1: ctr_59 port map(clk, c99, '0', seconds, s59);
    min1: ctr_59 port map(clk, incmin, '0', minutes, m59);
    hrs1: ctr_12 port map(clk, inchr, hours, am_pm);
    incmin <= (s59 and c99) or incm;
    inchr <= (m59 and s59 and c99) or inch;
    alarm_min: ctr_59 port map(clk, incma, '0', aminutes, open);
    alarm_hr: ctr_12 port map(clk, incha, ahours, aam_pm);
    c99 <= '1' when div100 = 99 else '0';
    process(clk)
    begin
      if clk'event and clk = '1' then
        if c99 = '1' then div100 <= 0;   -- divide by 100 counter
        else div100 <= div100 + 1;
        end if;
      if set_alarm = '1' then
        alarm_set <= not alarm_set;
      end if;
      if ((minutes = aminutes) and (hours = ahours) and (am_pm = aam_pm)) and
          seconds = 0 and alarm_set = '1' then
        ring <= '1';
      end if;
      if ring = '1' and c99 = '1' then
        alarm_ring_time <= alarm_ring_time + 1;
      end if;
      if alarm_ring_time = 50 or alarm_off = '1' then
        ring <= '0'; alarm_ring_time <= 0;
      end if;
    end if;
  end process;
end clock1;
