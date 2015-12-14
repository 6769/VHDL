
entity DFF is
 port(D, CLK: in bit;
 Q: buffer bit;
 QQN:buffer bit_vector(1 downto 0);
 QN: buffer bit := '1');
end DFF;
architecture SIMPLE of DFF is
begin
 QQN<=Q&QN;
 process(CLK)
 begin
 if CLK'event and CLK = '1' then
 Q <= D after 10 ns;
 QN <= not D after 10 ns;
 end if;
 end process;
end SIMPLE;