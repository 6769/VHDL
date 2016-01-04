library verilog;
use verilog.vl_types.all;
entity Controller_vlg_sample_tst is
    port(
        CLK             : in     vl_logic;
        D7              : in     vl_logic;
        D711            : in     vl_logic;
        D2312           : in     vl_logic;
        Eq              : in     vl_logic;
        Rb              : in     vl_logic;
        Reset           : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end Controller_vlg_sample_tst;
