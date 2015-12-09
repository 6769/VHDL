library verilog;
use verilog.vl_types.all;
entity clock_second_vlg_sample_tst is
    port(
        clk50Mhz        : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end clock_second_vlg_sample_tst;
