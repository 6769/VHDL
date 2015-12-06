library verilog;
use verilog.vl_types.all;
entity adjustAdder4_vlg_sample_tst is
    port(
        carryIn         : in     vl_logic;
        origin          : in     vl_logic_vector(3 downto 0);
        sampler_tx      : out    vl_logic
    );
end adjustAdder4_vlg_sample_tst;
