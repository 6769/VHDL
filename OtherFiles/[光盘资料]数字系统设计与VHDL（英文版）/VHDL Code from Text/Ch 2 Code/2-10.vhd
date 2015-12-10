entity FullAdder is
  port(X, Y, Cin: in bit;     --Inputs
       Cout, Sum: out bit);   --Outputs
end FullAdder;

architecture Equations of FullAdder is
begin			-- concurrent assignment statements
  Sum  <= X xor Y xor Cin after 10 ns; 
  Cout <= (X and Y) or (X and Cin) or (Y and Cin) after 10 ns;
end Equations;