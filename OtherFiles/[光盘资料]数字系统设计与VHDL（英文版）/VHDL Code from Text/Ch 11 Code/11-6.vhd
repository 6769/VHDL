library IEEE;
use IEEE.numeric_bit.all;
--divide by 100 BCD counter
entity CTR_99 is
  port(clk, inc, reset: in bit; dout: out unsigned(7 downto 0); t59: out bit);
end CTR_99;

architecture count99 of CTR_99 is
  signal dig1, dig0: unsigned(3 downto 0);
begin
  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then dig0 <= "0000"; dig1 <= "0000";
      else
        if inc = '1' then
          if dig0 = 9 then dig0 <= "0000";
            if dig1 = 9 then dig1 <= "0000";
            else dig1 <= dig1 + 1;
            end if;
          else dig0 <= dig0 + 1;
          end if;
        end if;
      end if;
    end if;
  end process;
  t59 <= '1' when (dig1 = 9 and dig0 = 9) else '0';
  dout <= dig1 & dig0;
end count99;
