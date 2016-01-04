library verilog;
use verilog.vl_types.all;
entity Roll_Sum_vlg_check_tst is
    port(
        hex0            : in     vl_logic_vector(2 downto 0);
        hex1            : in     vl_logic_vector(2 downto 0);
        Sum             : in     vl_logic_vector(3 downto 0);
        sampler_rx      : in     vl_logic
    );
end Roll_Sum_vlg_check_tst;
