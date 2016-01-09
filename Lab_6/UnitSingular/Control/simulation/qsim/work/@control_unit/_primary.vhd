library verilog;
use verilog.vl_types.all;
entity Control_unit is
    port(
        IRset           : in     vl_logic_vector(0 to 8);
        IRin            : out    vl_logic;
        Riout           : out    vl_logic_vector(0 to 7);
        Gout            : out    vl_logic;
        DINout          : out    vl_logic;
        Rin             : out    vl_logic_vector(0 to 7);
        Ain             : out    vl_logic;
        Gin             : out    vl_logic;
        AddSub          : out    vl_logic;
        Tstep_Q         : in     vl_logic_vector(1 downto 0);
        Clear           : out    vl_logic;
        Run             : in     vl_logic;
        Resetn          : in     vl_logic;
        Done            : out    vl_logic
    );
end Control_unit;
