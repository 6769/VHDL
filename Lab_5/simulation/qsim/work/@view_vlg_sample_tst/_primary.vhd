library verilog;
use verilog.vl_types.all;
entity View_vlg_sample_tst is
    port(
        CLK             : in     vl_logic;
        Rb              : in     vl_logic;
        Reset           : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end View_vlg_sample_tst;
