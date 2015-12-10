entity FullAdder is
  port(X, Y, Cin: in bit;     --Inputs
       Cout, Sum: out bit);   --Outputs
end FullAdder;

architecture Equations of FullAdder is
begin			-- concurrent assignment statements
  Sum  <= X xor Y xor Cin after 10 ns; 
  Cout <= (X and Y) or (X and Cin) or (Y and Cin) after 10 ns;
end Equations;

entity Adder4 is
  port(A, B: in bit_vector(3 downto 0); Ci: in bit;    -- Inputs
       S: out bit_vector(3 downto 0); Co: out bit);   -- Outputs
end Adder4;

architecture Structure of Adder4 is
component FullAdder
  port(X, Y, Cin: in bit;     -- Inputs
       Cout, Sum: out bit);   -- Outputs
end component;

signal C: bit_vector(4 downto 0);
begin
  C(0) <= Ci;
  -- generate four copies of the FullAdder
  FullAdd4: for i in 0 to 3 generate
  begin
    FAx: FullAdder port map (A(i), B(i), C(i), C(i+1), S(i));
  end generate FullAdd4;
  Co <= C(4);
end Structure;
