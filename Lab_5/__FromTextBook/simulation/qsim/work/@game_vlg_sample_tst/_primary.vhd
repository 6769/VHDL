library verilog;
use verilog.vl_types.all;
entity Game_vlg_sample_tst is
    port(
        Clk             : in     vl_logic;
        Rb              : in     vl_logic;
        Reset           : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end Game_vlg_sample_tst;
