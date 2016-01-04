library verilog;
use verilog.vl_types.all;
entity Controller_vlg_check_tst is
    port(
        Clear           : in     vl_logic;
        Lose            : in     vl_logic;
        Roll            : in     vl_logic;
        Sp              : in     vl_logic;
        State_debug     : in     vl_logic_vector(1 downto 0);
        Win             : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end Controller_vlg_check_tst;
