library verilog;
use verilog.vl_types.all;
entity View2_vlg_check_tst is
    port(
        hex0            : in     vl_logic_vector(7 downto 0);
        hex1            : in     vl_logic_vector(7 downto 0);
        Lose            : in     vl_logic;
        Win             : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end View2_vlg_check_tst;
