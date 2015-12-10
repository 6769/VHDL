entity latch_example2 is
  port(a: in integer range 0 to 3;
       b: out bit);
end latch_example2;

architecture test1 of latch_example2 is
begin
  process(a)
  begin
    case a is
      when 0 => b <= '1';
      when 1 => b <= '0';
      when 2 => b <= '1';
      when 3 => b <= '0';
    end case;
  end process;
end test1;
