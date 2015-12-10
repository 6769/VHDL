entity loopcode is
  port(clk, stop: in bit;
       done: out bit);
end loopcode;

architecture logic of loopcode is
  signal count: integer range 0 to 5 := 5;
begin
  process
  begin
    while stop = '0' and count /= 0 loop
      wait until clk'event and clk = '1';
      count <= count - 1;
      wait for 0 ns;
    end loop;
  wait until clk'event and clk = '1';
  end process;
  done <= '1' when stop = '1' or count = 0 else '0';
end logic;
