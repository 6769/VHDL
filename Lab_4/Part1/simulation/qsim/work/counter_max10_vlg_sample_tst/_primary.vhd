library verilog;
use verilog.vl_types.all;
entity counter_max10_vlg_sample_tst is
    port(
        clk             : in     vl_logic;
        limit           : in     vl_logic;
        reset           : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end counter_max10_vlg_sample_tst;
