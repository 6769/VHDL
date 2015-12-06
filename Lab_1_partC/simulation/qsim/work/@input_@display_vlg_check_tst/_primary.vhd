library verilog;
use verilog.vl_types.all;
entity Input_Display_vlg_check_tst is
    port(
        adder1_hex_display: in     vl_logic_vector(15 downto 0);
        adder2_hex_display: in     vl_logic_vector(15 downto 0);
        sum             : in     vl_logic_vector(23 downto 0);
        sampler_rx      : in     vl_logic
    );
end Input_Display_vlg_check_tst;
