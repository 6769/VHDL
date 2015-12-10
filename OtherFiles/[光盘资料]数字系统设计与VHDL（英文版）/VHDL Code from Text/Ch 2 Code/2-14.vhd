entity gates is
  port(A, B, C: in bit; D: buffer bit; E: out bit);
end gates;

architecture example of gates is
begin
  D <= A or B after 5 ns; -- statement 1
  E <= C or D after 5 ns; -- statement 2
end example;
