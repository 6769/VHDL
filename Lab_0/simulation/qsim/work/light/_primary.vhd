library verilog;
use verilog.vl_types.all;
entity light is
    port(
        x1              : in     vl_logic;
        x2              : in     vl_logic;
        f               : out    vl_logic;
        g               : out    vl_logic;
        h               : out    vl_logic
    );
end light;
