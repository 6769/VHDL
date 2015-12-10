-- This is the and function from the numeric std library.  
-- "and_table" is defined there - the library is needed for this code to work.
-- However, defining the function a second time will cause errors.
-- This code is included only for completeness.

function "and" (l: std_ulogic; r: std_ulogic ) return UX01 is
begin
  return (and_table(l, r));
end "and"; -- end of function for unresolved standard logic 

function "and" (l, r: std_logic_vector) return std_logic_vector is
  alias lv : std_logic_vector ( 1 to l'LENGTH ) is l; --alias makes index range
  alias rv : std_logic_vector ( 1 to r'LENGTH ) is r; -- in same direction
  variable result : std_logic_vector ( 1 to l'LENGTH );
begin
  if (l'LENGTH /= r'LENGTH ) then
    assert FALSE
      report "arguments of overloaded 'and' operator are not of the same
              length"
      severity FAILURE;
  else
    for i in result'RANGE loop
      result(i) := and_table(lv(i), rv(i));
    end loop;
  end if;
  return result;
end "and";
