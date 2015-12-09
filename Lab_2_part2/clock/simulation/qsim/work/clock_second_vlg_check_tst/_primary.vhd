library verilog;
use verilog.vl_types.all;
entity clock_second_vlg_check_tst is
    port(
        second          : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end clock_second_vlg_check_tst;
