library verilog;
use verilog.vl_types.all;
entity View_input_vlg_sample_tst is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        w               : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end View_input_vlg_sample_tst;
