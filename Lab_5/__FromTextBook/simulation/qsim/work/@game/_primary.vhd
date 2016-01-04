library verilog;
use verilog.vl_types.all;
entity Game is
    port(
        Rb              : in     vl_logic;
        Reset           : in     vl_logic;
        Clk             : in     vl_logic;
        Win             : out    vl_logic;
        Lose            : out    vl_logic
    );
end Game;
