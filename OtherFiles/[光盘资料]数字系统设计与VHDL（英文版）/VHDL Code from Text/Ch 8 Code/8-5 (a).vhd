entity attr_ex is
  port(B, C: in bit);
end attr_ex;

architecture test of attr_ex is
signal A, C_delayed5, A_trans: bit;
signal A_stable5, A_quiet5: boolean;
begin
  A <= B and C;
  C_delayed5 <= C'delayed(5 ns);
  A_trans <= A'transaction;
  A_stable5 <= A'stable(5 ns);
  A_quiet5 <= A'quiet(5 ns);
end test;
