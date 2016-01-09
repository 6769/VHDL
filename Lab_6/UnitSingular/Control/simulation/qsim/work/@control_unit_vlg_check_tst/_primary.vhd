library verilog;
use verilog.vl_types.all;
entity Control_unit_vlg_check_tst is
    port(
        AddSub          : in     vl_logic;
        Ain             : in     vl_logic;
        Clear           : in     vl_logic;
        DINout          : in     vl_logic;
        Done            : in     vl_logic;
        Gin             : in     vl_logic;
        Gout            : in     vl_logic;
        IRin            : in     vl_logic;
        Rin             : in     vl_logic_vector(0 to 7);
        Riout           : in     vl_logic_vector(0 to 7);
        sampler_rx      : in     vl_logic
    );
end Control_unit_vlg_check_tst;
