entity AddFunction_Tester is
end AddFunction_Tester;

architecture internal of AddFunction_Tester is
  constant N: integer := 11;
  type bv_arr is array(1 to N) of bit_vector(3 downto 0);
  type bit_arr is array(1 to N) of bit;
  constant addend_array: bv_arr := ("0111", "1101", "0101", "1101", 
            "0111", "1000", "0111", "1000", "0000", "1111", "0000");
  constant augend_array: bv_arr := ("0101", "0101", "1101", "1101", 
            "0111", "0111", "1000", "1000", "1101", "1111", "0000");
  constant cin_array: bit_arr := ('0', '0', '0', '0', '1', '0', '0',
            '0', '1', '1', '0');
  constant sum_array: bv_arr := ("1100", "0010", "0010", "1010",
            "1111", "1111", "1111", "0000", "1110", "1111", "0000");
  constant cout_array: bit_arr := ('0', '1', '1', '1', '0', '0', '0',
            '1', '0', '1', '0');
  signal result, expected: bit_vector(4 downto 0);
  
  function add4 (A, B: bit_vector(3 downto 0); carry: bit)
    return bit_vector is
    variable cout: bit;
    variable cin: bit := carry;
    variable sum: bit_vector(4 downto 0) := "00000";
  begin
    loop1: for i in 0 to 3 loop
      cout := (A(i) and B(i)) or (A(i) and cin) or (B(i) and cin);
      sum(i) := A(i) xor B(i) xor cin;
      cin := cout;
    end loop loop1;
    sum(4) := cout;
    return sum;
  end add4;

begin
  process
  begin
    for i in 1 to N loop
      result <= add4(addend_array(i),augend_array(i),cin_array(i));
      expected <= cout_array(i) & sum_array(i);
      wait for 1 ns;
      assert result = expected
        report "Incorrect sum" severity error;
    end loop;
    report "Testing finished";
  end process;
end internal;