library verilog;
use verilog.vl_types.all;
entity DiceGame_controller_vlg_check_tst is
    port(
        Lose            : in     vl_logic;
        Roll            : in     vl_logic;
        Win             : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end DiceGame_controller_vlg_check_tst;
