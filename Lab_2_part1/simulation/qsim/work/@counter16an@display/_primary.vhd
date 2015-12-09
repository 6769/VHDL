library verilog;
use verilog.vl_types.all;
entity Counter16anDisplay is
    port(
        clk             : in     vl_logic;
        enable          : in     vl_logic;
        clear           : in     vl_logic;
        hex0            : out    vl_logic_vector(7 downto 0);
        hex1            : out    vl_logic_vector(7 downto 0);
        hex2            : out    vl_logic_vector(7 downto 0);
        hex3            : out    vl_logic_vector(7 downto 0)
    );
end Counter16anDisplay;
