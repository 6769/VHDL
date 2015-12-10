library IEEE;
use IEEE.numeric_bit.all; -- any package with overloaded add and subtract

entity Scoreboard is
  port(clk, rst, inc, dec: in bit;
       seg7disp1, seg7disp0: out unsigned(6 downto 0));
end Scoreboard;

architecture Behavioral of Scoreboard is
signal State: integer range 0 to 1;
signal BCD1, BCD0: unsigned(3 downto 0) := "0000"; -- unsigned bit vector
signal rstcnt: integer range 0 to 4 := 0;
type sevsegarray is array (0 to 9) of unsigned(6 downto 0);
constant seg7Rom: sevsegarray :=
  ("0111111", "0000110", "1011011", "1001111", "1100110", "1101101", "1111100",
   "0000111", "1111111", "1100111"); -- active high with “gfedcba” order
begin
  process(clk)
  begin
    if clk'event and clk = '1' then
      case State is
        when 0 => -- initial state
          BCD1 <= "0000"; BCD0 <= "0000"; -- clear counter
          rstcnt <= 0; -- reset RESETCOUNT
          State <= 1;
        when 1 => -- state in which the scoreboard waits for inc and dec
          if rst = '1' then
            if rstcnt = 4 then -- checking whether 5th reset cycle
              State <= 0;
            else rstcnt <= rstcnt + 1;
            end if;
          elsif inc = '1' and dec = '0' then
            rstcnt <= 0;
            if BCD0 < "1001" then
              BCD0 <= BCD0 + 1; -- library with overloaded "+" required 
            elsif BCD1 < "1001" then
              BCD1 <= BCD1 + 1;
              BCD0 <= "0000";
            end if;
          elsif dec = '1' and inc = '0' then
            rstcnt <= 0;
            if BCD0 > "0000" then
              BCD0 <= BCD0 - 1; -- library with overloaded "-" required
            elsif BCD1 > "0000" then
              BCD1 <= BCD1 - 1;
              BCD0 <= "1001";
            end if;
          elsif (inc = '1' and dec = '1') or (inc = '0' and dec = '0') then
            rstcnt <= 0;
          end if;
      end case;
    end if;
  end process;
  seg7disp0 <= seg7rom(to_integer(BCD0)); -- type conversion function from
  seg7disp1 <= seg7rom(to_integer(BCD1)); -- IEEE numeric_bit package used
end Behavioral;