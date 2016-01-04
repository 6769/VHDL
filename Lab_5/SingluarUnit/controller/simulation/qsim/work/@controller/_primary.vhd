library verilog;
use verilog.vl_types.all;
entity Controller is
    port(
        Rb              : in     vl_logic;
        Reset           : in     vl_logic;
        Eq              : in     vl_logic;
        D7              : in     vl_logic;
        D711            : in     vl_logic;
        D2312           : in     vl_logic;
        CLK             : in     vl_logic;
        State_debug     : out    vl_logic_vector(1 downto 0);
        Sp              : out    vl_logic;
        Roll            : out    vl_logic;
        Win             : out    vl_logic;
        Lose            : out    vl_logic;
        Clear           : out    vl_logic
    );
end Controller;
