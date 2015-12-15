library verilog;
use verilog.vl_types.all;
entity Threebit_BCD_counter_vlg_check_tst is
    port(
        Counter_Result  : in     vl_logic_vector(11 downto 0);
        sampler_rx      : in     vl_logic
    );
end Threebit_BCD_counter_vlg_check_tst;
