library verilog;
use verilog.vl_types.all;
entity rotate_shift_register_vlg_check_tst is
    port(
        hex0            : in     vl_logic_vector(7 downto 0);
        hex1            : in     vl_logic_vector(7 downto 0);
        hex2            : in     vl_logic_vector(7 downto 0);
        hex3            : in     vl_logic_vector(7 downto 0);
        hex4            : in     vl_logic_vector(7 downto 0);
        hex5            : in     vl_logic_vector(7 downto 0);
        hex6            : in     vl_logic_vector(7 downto 0);
        hex7            : in     vl_logic_vector(7 downto 0);
        sampler_rx      : in     vl_logic
    );
end rotate_shift_register_vlg_check_tst;
