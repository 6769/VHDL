-- This package provides an overloaded function for the plus operator

package bit_overload is
  function "+" (Add1, Add2: bit_vector)
    return bit_vector;
end bit_overload;

package body bit_overload is
  -- This function returns a bit_vector sum of two bit_vector operands
  -- The add is performed bit by bit with an internal carry
  function "+" (Add1, Add2: bit_vector)
    return bit_vector is

  variable sum: bit_vector(Add1'length-1 downto 0);
  variable c: bit := '0';                  -- no carry in
  alias n1: bit_vector(Add1'length-1 downto 0) is Add1;
  alias n2: bit_vector(Add2'length-1 downto 0) is Add2;
  begin
    for i in sum'reverse_range loop
      sum(i) := n1(i) xor n2(i) xor c;
      c := (n1(i) and n2(i)) or (n1(i) and c) or (n2(i) and c);
    end loop;
    return (sum);
  end "+";
end bit_overload;
