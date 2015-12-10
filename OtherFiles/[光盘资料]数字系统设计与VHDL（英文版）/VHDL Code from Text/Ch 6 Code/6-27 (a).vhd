entity case_example is
  port(a: in integer range 0 to 3;
       b: out integer range 0 to 3);
end case_example;

architecture test1 of case_example is
begin
  process(a)
  begin
    case a is
      when 0 => b <= 1;
      when 1 => b <= 3;
      when 2 => b <= 0;
      when 3 => b <= 1;
    end case;
  end process;
end test1;
