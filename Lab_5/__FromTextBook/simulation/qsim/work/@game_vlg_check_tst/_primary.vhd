library verilog;
use verilog.vl_types.all;
entity Game_vlg_check_tst is
    port(
        Lose            : in     vl_logic;
        Win             : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end Game_vlg_check_tst;
