library verilog;
use verilog.vl_types.all;
entity NumberAnDisplay_vlg_sample_tst is
    port(
        V               : in     vl_logic_vector(3 downto 0);
        sampler_tx      : out    vl_logic
    );
end NumberAnDisplay_vlg_sample_tst;
