library verilog;
use verilog.vl_types.all;
entity control_vlg_sample_tst is
    port(
        d7              : in     vl_logic;
        d711            : in     vl_logic;
        d2312           : in     vl_logic;
        eq              : in     vl_logic;
        rb              : in     vl_logic;
        reset           : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end control_vlg_sample_tst;
