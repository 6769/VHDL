library IEEE;
use IEEE.numeric_bit.all;

entity stopwatch is
  port(clk, reset, start_stop: in bit;
       swhundreths, swseconds, swminutes: out unsigned(7 downto 0));
end stopwatch;

architecture stopwatch1 of stopwatch is
  component CTR_59 is
    port(clk, inc, reset: in bit; dout: out unsigned(7 downto 0); t59: out bit);
  end component;
  component CTR_99 is
    port(clk, inc, reset: in bit; dout: out unsigned(7 downto 0); t59: out bit);
  end component;
  signal swc99, s59, counting, swincmin: bit;
begin
  ctr2: ctr_99 port map(clk, counting, reset, swhundreths, swc99);
    --counts hundreths of seconds
  sec2: ctr_59 port map(clk, swc99, reset, swseconds, s59);
    --counts seconds
  min2: ctr_59 port map(clk, swincmin, reset, swminutes, open);
    --counts minutes
  swincmin <= s59 and swc99;
  process(clk)
  begin
    if clk'event and clk = '1' then
      if start_stop = '1' then
        counting <= not counting;
      end if;
    end if;
  end process;
end stopwatch1;
