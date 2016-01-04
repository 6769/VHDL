library verilog;
use verilog.vl_types.all;
entity View2 is
    port(
        Rb              : in     vl_logic;
        Reset           : in     vl_logic;
        CLK             : in     vl_logic;
        Win             : out    vl_logic;
        Lose            : out    vl_logic;
        hex0            : out    vl_logic_vector(7 downto 0);
        hex1            : out    vl_logic_vector(7 downto 0)
    );
end View2;
