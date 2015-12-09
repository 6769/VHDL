library verilog;
use verilog.vl_types.all;
entity Counter16anDisplay_vlg_check_tst is
    port(
        hex0            : in     vl_logic_vector(7 downto 0);
        hex1            : in     vl_logic_vector(7 downto 0);
        hex2            : in     vl_logic_vector(7 downto 0);
        hex3            : in     vl_logic_vector(7 downto 0);
        sampler_rx      : in     vl_logic
    );
end Counter16anDisplay_vlg_check_tst;
