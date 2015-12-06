library verilog;
use verilog.vl_types.all;
entity NumberAnDisplay_vlg_check_tst is
    port(
        M               : in     vl_logic_vector(3 downto 0);
        segment7        : in     vl_logic_vector(6 downto 0);
        segment7_1      : in     vl_logic_vector(6 downto 0);
        segment7_1_point: in     vl_logic;
        segment7_point  : in     vl_logic;
        z               : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end NumberAnDisplay_vlg_check_tst;
