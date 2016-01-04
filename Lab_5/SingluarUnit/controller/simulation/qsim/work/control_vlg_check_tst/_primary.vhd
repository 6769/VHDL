library verilog;
use verilog.vl_types.all;
entity control_vlg_check_tst is
    port(
        lose            : in     vl_logic;
        roll            : in     vl_logic;
        sp              : in     vl_logic;
        win             : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end control_vlg_check_tst;
