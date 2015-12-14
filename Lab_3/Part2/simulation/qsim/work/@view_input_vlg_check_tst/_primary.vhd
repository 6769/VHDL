library verilog;
use verilog.vl_types.all;
entity View_input_vlg_check_tst is
    port(
        state8_0        : in     vl_logic_vector(8 downto 0);
        z               : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end View_input_vlg_check_tst;
