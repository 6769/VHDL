entity bcd_seven is
  port(bcd: in bit_vector(3 downto 0);
       seven: out bit_vector(7 downto 1));
                  -- LSB is segment a of the display. MSB is segment g
end bcd_seven;

architecture behavioral of bcd_seven is
begin
  process(bcd)
  begin
    case bcd is
      when "0000" => seven <= "0111111";
      when "0001" => seven <= "0000110";
      when "0010" => seven <= "1011011";
      when "0011" => seven <= "1001111";
      when "0100" => seven <= "1100110";
      when "0101" => seven <= "1101101";
      when "0110" => seven <= "1111101";
      when "0111" => seven <= "0000111";
      when "1000" => seven <= "1111111";
      when "1001" => seven <= "1101111";
      when others => null;
    end case;
  end process;
end behavioral;
