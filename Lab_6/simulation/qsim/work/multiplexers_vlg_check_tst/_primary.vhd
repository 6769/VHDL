library verilog;
use verilog.vl_types.all;
entity multiplexers_vlg_check_tst is
    port(
        out_to_bus      : in     vl_logic_vector(15 downto 0);
        sampler_rx      : in     vl_logic
    );
end multiplexers_vlg_check_tst;
