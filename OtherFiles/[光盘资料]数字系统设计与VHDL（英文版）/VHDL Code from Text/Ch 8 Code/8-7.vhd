entity Addvec2_Tester is
end Addvec2_Tester;

architecture internal of Addvec2_Tester is
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
  signal addend, augend, mysum: bit_vector(3 downto 0);
  signal cin, mycout: bit;
  
  procedure Addvec2 (Add1, Add2: in bit_vector; Cin: in bit;
                     signal Sum: out bit_vector;
                     signal Cout: out bit) is
    variable C: bit := Cin;
    alias n1: bit_vector(Add1'length-1 downto 0) is Add1;
    alias n2: bit_vector(Add2'length-1 downto 0) is Add2;
    alias S: bit_vector(Sum'length-1 downto 0) is Sum;
  begin
    assert ((n1'length = n2'length) and (n1'length = S'length))
      report "Vector lengths must be equal!"
      severity error;
    for i in s'reverse_range loop   -- reverse range makes you start from LSB
      S(i) <= n1(i) xor n2(i) xor C;
      C := (n1(i) and n2(i)) or (n1(i) and C) or (n2(i) and C);
    end loop;
    Cout <= C;
  end Addvec2;
begin
  process
  begin
    for i in 1 to N loop
      addend <= addend_array(i);
      augend <= augend_array(i);
      cin <= cin_array(i);
      wait for 0 ns;
      Addvec2(addend,augend,cin,mysum,mycout);
      wait for 1 ns;
      assert sum_array(i) = mysum and cout_array(i) = mycout
        report "Incorrect sum" severity error;
    end loop;
 
    wait for 1 ns;
    Addvec2("0001","00001",'0',mysum,mycout);
    wait for 1 ns;
    report "Testing finished";
  end process;
end internal;