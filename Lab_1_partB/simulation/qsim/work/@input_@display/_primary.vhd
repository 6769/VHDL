library verilog;
use verilog.vl_types.all;
entity Input_Display is
    port(
        adder1          : in     vl_logic_vector(7 downto 0);
        adder2          : in     vl_logic_vector(7 downto 0);
        adder1_hex_display: out    vl_logic_vector(15 downto 0);
        adder2_hex_display: out    vl_logic_vector(15 downto 0);
        sum             : out    vl_logic_vector(23 downto 0)
    );
end Input_Display;
