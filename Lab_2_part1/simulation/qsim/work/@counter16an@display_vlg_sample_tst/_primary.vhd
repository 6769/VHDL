library verilog;
use verilog.vl_types.all;
entity Counter16anDisplay_vlg_sample_tst is
    port(
        clear           : in     vl_logic;
        clk             : in     vl_logic;
        enable          : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end Counter16anDisplay_vlg_sample_tst;
