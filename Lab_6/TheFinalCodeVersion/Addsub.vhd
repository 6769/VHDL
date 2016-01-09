library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity Addsub_Unit is
    Generic (n : Integer := 16);
    port(
        a,b:            in std_logic_vector(n-1 downto 0);
        select_add_sub: in std_logic;
        result:         buffer std_logic_vector(n-1 downto 0)
        );
end entity Addsub_Unit;

architecture Behavior of Addsub_Unit is

begin
    process(select_add_sub,a,b)
    begin
        case select_add_sub is
            when '0'=>
                result<=a+b;
            when '1'=>
                result<=a-b;
            when others=>
                result<=(others=>'Z');
        end case;
    
    end process;


end architecture Behavior;