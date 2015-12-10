entity Array_Mult is
  port(X, Y: in bit_vector(3 downto 0);
       P: out bit_vector(7 downto 0));
end Array_Mult;

architecture Behavioral of Array_Mult is
signal C1, C2, C3: bit_vector(3 downto 0);
signal S1, S2, S3: bit_vector(3 downto 0);
signal XY0, XY1, XY2, XY3: bit_vector(3 downto 0);
component FullAdder
  port(X, Y, Cin: in bit;
       Cout, Sum: out bit);
end component;
component HalfAdder
  port(X, Y: in bit;
       Cout, Sum: out bit);
end component;
begin
  XY0(0) <= X(0) and Y(0);   XY1(0) <= X(0) and Y(1);
  XY0(1) <= X(1) and Y(0);   XY1(1) <= X(1) and Y(1);
  XY0(2) <= X(2) and Y(0);   XY1(2) <= X(2) and Y(1);
  XY0(3) <= X(3) and Y(0);   XY1(3) <= X(3) and Y(1);

  XY2(0) <= X(0) and Y(2);   XY3(0) <= X(0) and Y(3);
  XY2(1) <= X(1) and Y(2);   XY3(1) <= X(1) and Y(3);
  XY2(2) <= X(2) and Y(2);   XY3(2) <= X(2) and Y(3);
  XY2(3) <= X(3) and Y(2);   XY3(3) <= X(3) and Y(3);

  FA1: FullAdder port map (XY0(2), XY1(1), C1(0), C1(1), S1(1));
  FA2: FullAdder port map (XY0(3), XY1(2), C1(1), C1(2), S1(2));
  FA3: FullAdder port map (S1(2), XY2(1), C2(0), C2(1), S2(1));
  FA4: FullAdder port map (S1(3), XY2(2), C2(1), C2(2), S2(2));
  FA5: FullAdder port map (C1(3), XY2(3), C2(2), C2(3), S2(3));
  FA6: FullAdder port map (S2(2), XY3(1), C3(0), C3(1), S3(1));
  FA7: FullAdder port map (S2(3), XY3(2), C3(1), C3(2), S3(2));
  FA8: FullAdder port map (C2(3), XY3(3), C3(2), C3(3), S3(3));
  HA1: HalfAdder port map (XY0(1), XY1(0), C1(0), S1(0));
  HA2: HalfAdder port map (XY1(3), C1(2), C1(3), S1(3));
  HA3: HalfAdder port map (S1(1), XY2(0), C2(0), S2(0));
  HA4: HalfAdder port map (S2(1), XY3(0), C3(0), S3(0));

  P(0) <= XY0(0);
  P(1) <= S1(0);
  P(2) <= S2(0);
  P(3) <= S3(0);
  P(4) <= S3(1);
  P(5) <= S3(2);
  P(6) <= S3(3);
  P(7) <= C3(3);
end Behavioral;

-- Full Adder and half adder entity and architecture descriptions
-- should be in the project
entity FullAdder is 
  port(X, Y, Cin: in bit;
       Cout, Sum: out bit);
end FullAdder;

architecture equations of FullAdder is
begin
  Sum <= X xor Y xor Cin;
  Cout <= (X and Y) or (X and Cin) or (Y and Cin);
end equations;

entity HalfAdder is 
  port(X, Y: in bit;
       Cout, Sum: out bit);
end HalfAdder;

architecture equations of HalfAdder is
begin
  Sum <= X xor Y;
  Cout <= X and Y;
end equations;