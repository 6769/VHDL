library verilog;
use verilog.vl_types.all;
entity lab50_vlg_sample_tst is
    port(
        clk_28m         : in     vl_logic;
        clk_50m         : in     vl_logic;
        rb              : in     vl_logic;
        reset           : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end lab50_vlg_sample_tst;
