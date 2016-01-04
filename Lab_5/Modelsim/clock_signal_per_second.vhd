library ieee;
use ieee.numeric_bit.all;

entity clock_signal_per_second is
    port(clk:in bit;
	second_output:buffer bit);

end entity clock_signal_per_second;

architecture behavior of clock_signal_per_second is
signal counter_for_osc_signal:unsigned(31 downto 0);
constant Terminator:integer:=25000;--25*1000*1000
begin
    process
    begin
        wait until clk'event and clk='1';
        if counter_for_osc_signal<Terminator then counter_for_osc_signal<=counter_for_osc_signal+1;
        else counter_for_osc_signal<=(others=>'0');
            second_output<=not second_output;
        end if;
    end process;

end architecture behavior;