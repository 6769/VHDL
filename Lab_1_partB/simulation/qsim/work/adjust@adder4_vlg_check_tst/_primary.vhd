library verilog;
use verilog.vl_types.all;
entity adjustAdder4_vlg_check_tst is
    port(
        adjusted        : in     vl_logic_vector(3 downto 0);
        carryAdjusted   : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end adjustAdder4_vlg_check_tst;
