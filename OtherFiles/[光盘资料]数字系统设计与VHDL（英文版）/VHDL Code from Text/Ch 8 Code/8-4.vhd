entity Addvec_Tester is
end Addvec_Tester;

architecture internal of Addvec_Tester is
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
  signal sum: bit_vector(3 downto 0);
  signal cout: bit;
  
  procedure Addvec (Add1, Add2: in bit_vector; Cin: in bit;
                    signal Sum: out bit_vector; signal Cout: out bit;
                    n: in positive) is
    variable C: bit;
  begin
    C := Cin;
    for i in 0 to n-1 loop
      Sum(i) <= Add1(i) xor Add2(i) xor C;
      C := (Add1(i) and Add2(i)) or (Add1(i) and C) or (Add2(i) and C);
    end loop;
    Cout <= C;
  end Addvec;
begin
  process
  begin
    for i in 1 to N loop
      Addvec(addend_array(i),augend_array(i),cin_array(i),sum,cout,4);
      wait for 1 ns;
      assert sum_array(i) = sum and cout_array(i) = cout
        report "Incorrect sum" severity error;
    end loop;
    report "Testing finished";
  end process;
end internal;