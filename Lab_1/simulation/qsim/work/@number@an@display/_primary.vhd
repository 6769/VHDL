library verilog;
use verilog.vl_types.all;
entity NumberAnDisplay is
    port(
        V               : in     vl_logic_vector(3 downto 0);
        z               : out    vl_logic;
        M               : out    vl_logic_vector(3 downto 0);
        segment7        : out    vl_logic_vector(6 downto 0);
        segment7_point  : out    vl_logic;
        segment7_1      : out    vl_logic_vector(6 downto 0);
        segment7_1_point: out    vl_logic
    );
end NumberAnDisplay;
