LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY decoder_1_6 IS
PORT(
    m:IN STD_LOGIC_vector(3 downto 0);
    led_vector:out bit_vector(7 DOWNTO 0));
END decoder_1_6;

ARCHITECTURE decoder_architecture OF decoder_1_6 IS
BEGIN
    PROCESS(m)
    BEGIN
     CASE m IS
        WHEN "0001" => led_vector<="11111001";--F9=>1
        WHEN "0010" => led_vector<="10100100";--A4=>2
        WHEN "0011" => led_vector<="10110000";--B0=>3
        WHEN "0100" => led_vector<="10011001";--99=>4
        WHEN "0101" => led_vector<="10010010";--92=>5
        WHEN "0110" => led_vector<="10000010";--82=>6
        WHEN others => led_vector<="11111111";--FF=>≤ª¡¡
    END CASE;
    END PROCESS;
END decoder_architecture;