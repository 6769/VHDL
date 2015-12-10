-- System with BILBO test bench

entity BILBO_test is
end BILBO_test;

architecture Btest of BILBO_test is
  component BILBO_System is
    port (Clk, LdA, LdB, LdC, B1, B2, Si: in bit;
          So: out bit;
          DBus: in bit_vector(3 downto 0);
          Output: inout bit_vector(4 downto 0));
  end component;
  signal Clk: bit := '0';
  signal LdA, LdB, LdC, B1, B2, Si, So: bit := '0';
  signal DBus: bit_vector(3 downto 0);
  signal Output: bit_vector(4 downto 0);
  signal Sig: bit_vector(4 downto 0);

  constant test_vector: bit_vector(12 downto 0) := "1000110000000";
  constant test_result: bit_vector(4 downto 0) := "01011";
begin
  clk <= not clk after 25 ns;
  Sys: BILBO_System port map(Clk,Lda,LdB,LdC,B1,B2,Si,So,DBus,Output);
  process
  begin
    B1 <= '0'; B2 <= '0';           -- Shift in test vector
    for i in test_vector'right to test_vector'left loop
      Si <= test_vector(i);
      wait until (clk = '1');
    end loop;

    B1 <= '0'; B2 <= '1';           -- Use PRPG and MISR
    for i in 1 to 15 loop
      wait until (clk = '1');
    end loop;

    B1 <= '0'; B2 <= '0';           -- Shift signature out
    for i in 0 to 5 loop
      Sig <= So & Sig(4 downto 1);
      wait until (clk = '1');
    end loop;

    if (Sig = test_result) then     -- Compare signature
      report "System passed test.";
    else
      report "System did not pass test!";
    end if;

    wait;
  end process;
end Btest;