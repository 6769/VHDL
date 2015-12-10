entity nogates is
  port(A, B, C: in bit;
       D: buffer bit;
       E: out bit);
end nogates;

architecture behave of nogates is
begin
  process(A, B, C)
  begin
    D <= A or B after 5 ns; -- statement 1
    E <= C or D after 5 ns; -- statement 2
  end process;
end behave;
