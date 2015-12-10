entity Parity_Tester is
end Parity_Tester;

architecture internal of Parity_Tester is
  type arr1 is array (0 to 15) of bit_vector(3 downto 0);
  constant input: arr1 := ("0000","0001","0010","0011","0100","0101","0110","0111",
                           "1000","1001","1010","1011","1100","1101","1110","1111");
  type arr2 is array (0 to 15) of bit_Vector(4 downto 0);
  constant output: arr2 := ("00000","00011","00101","00110","01001","01010","01100","01111",
                            "10001","10010","10100","10111","11000","11011","11101","11110");
  signal result: bit_Vector(4 downto 0);

  function parity (A: bit_vector(3 downto 0))
    return bit_vector is
  variable parity: bit;
  variable B: bit_vector(4 downto 0);
  begin
    parity := a(0) xor a(1) xor a(2) xor a(3);
    B := A & parity;
    return B;
  end parity;
begin
  process
  begin
  for i in 0 to 15 loop
    Result <= parity(input(i));
    wait for 1 ns;
    assert Result = output(i)
      report "parity does not match" severity error;
  end loop;
  report "Testing finished";
  end process;
end internal;