
entity Adder is 
    port(add1,add2:in integer range 6 downto 1;
    Sum:out integer range 12 downto 2);
end entity Adder;
architecture Behavior of Adder is
begin
    Sum<=add1+add2;
end architecture Behavior;