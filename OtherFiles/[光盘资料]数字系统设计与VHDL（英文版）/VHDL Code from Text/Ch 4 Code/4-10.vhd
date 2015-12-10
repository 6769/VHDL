entity CLA4 is
  port(A, B: in bit_vector(3 downto 0); Ci: in bit;          -- Inputs
       S: out bit_vector(3 downto 0); Co, PG, GG: out bit);  -- Outputs
end CLA4;

architecture Structure of CLA4 is
component GPFullAdder
  port(X, Y, Cin: in bit;    -- Inputs
       G, P, Sum: out bit);  -- Outputs
end component;
component CLALogic is
  port(G, P: in bit_vector(3 downto 0); Ci: in bit;          -- Inputs
       C: out bit_vector(3 downto 1); Co, PG, GG: out bit);  -- Outputs
end component;

signal G, P: bit_vector(3 downto 0); -- carry internal signals
signal C: bit_vector(3 downto 1);
begin      --instantiate four copies of the GPFullAdder
  CarryLogic: CLALogic port map (G, P, Ci, C, Co, PG, GG);
  FA0: GPFullAdder port map (A(0), B(0), Ci, G(0), P(0), S(0));
  FA1: GPFullAdder port map (A(1), B(1), C(1), G(1), P(1), S(1));
  FA2: GPFullAdder port map (A(2), B(2), C(2), G(2), P(2), S(2));
  FA3: GPFullAdder port map (A(3), B(3), C(3), G(3), P(3), S(3));
end Structure;

entity CLALogic is
  port(G, P: in bit_vector(3 downto 0); Ci: in bit;          -- Inputs
       C: out bit_vector(3 downto 1); Co, PG, GG: out bit);  -- Outputs
end CLALogic;

architecture Equations of CLALogic is
signal GG_int, PG_int: bit;
begin      -- concurrent assignment statements
  C(1) <= G(0) or (P(0) and Ci);
  C(2) <= G(1) or (P(1) and G(0)) or (P(1) and P(0) and Ci);
  C(3) <= G(2) or (P(2) and G(1)) or (P(2) and P(1) and G(0)) or
          (P(2) and P(1) and P(0) and Ci);
  PG_int <= P(3) and P(2) and P(1) and P(0);
  GG_int <= G(3) or (P(3) and G(2)) or (P(3) and P(2) and G(1)) or
            (P(3) and P(2) and P(1) and G(0));
  Co <= GG_int or (PG_int and Ci);
  PG <= PG_int;
  GG <= GG_int;
end Equations;

entity GPFullAdder is
  port(X, Y, Cin: in bit;    -- Inputs
       G, P, Sum: out bit);  -- Outputs
end GPFullAdder;

architecture Equations of GPFullAdder is
signal P_int: bit;
begin                        -- concurrent assignment statements
  G <= X and Y;
  P <= P_int;
  P_int <= X xor Y;
  Sum <= P_int xor Cin; 
end Equations;
