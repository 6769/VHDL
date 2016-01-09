library verilog;
use verilog.vl_types.all;
entity Addsub_vlg_check_tst is
    port(
        result          : in     vl_logic_vector(15 downto 0);
        sampler_rx      : in     vl_logic
    );
end Addsub_vlg_check_tst;
