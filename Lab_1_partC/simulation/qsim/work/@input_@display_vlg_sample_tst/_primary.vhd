library verilog;
use verilog.vl_types.all;
entity Input_Display_vlg_sample_tst is
    port(
        adder1          : in     vl_logic_vector(7 downto 0);
        adder2          : in     vl_logic_vector(7 downto 0);
        sampler_tx      : out    vl_logic
    );
end Input_Display_vlg_sample_tst;
