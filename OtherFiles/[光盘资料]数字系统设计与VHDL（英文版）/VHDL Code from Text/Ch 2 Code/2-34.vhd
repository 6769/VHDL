entity no_syn is
  port(A,B, CLK: in bit; 
       D: out bit);
end no_syn;

architecture no_synthesis of no_syn is
signal C: bit;
begin
  process(Clk)
  begin
    if (Clk='1' and Clk'event) then
      C <= A and B;
    end if;
  end process;
end no_synthesis;
