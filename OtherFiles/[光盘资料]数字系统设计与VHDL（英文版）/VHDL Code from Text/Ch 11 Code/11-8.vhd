library IEEE;
use IEEE.numeric_bit.all;
--this counter counts hours 1 to 12 and toggles am_pm
entity CTR_12 is
  port(clk, inc: in bit; dout: out unsigned(7 downto 0); am_pm: inout bit);
end CTR_12;

architecture count12 of CTR_12 is
  signal dig0: unsigned(3 downto 0);
  signal dig1: bit;
begin
  process(clk)
  begin
    if clk'event and clk = '1' then
      if inc = '1' then
        if dig1 = '1' and dig0 = 2 then
          dig1 <= '0'; dig0 <= "0001";
        else
          if dig0 = 9 then dig0 <= "0000"; dig1 <= '1';
          else dig0 <= dig0 + 1;
          end if;
          if dig1 = '1' and dig0 = 1 then am_pm <= not am_pm;
          end if;
        end if;
      end if;
    end if;
  end process;
  dout <= "000" & dig1 & dig0;
end count12;
