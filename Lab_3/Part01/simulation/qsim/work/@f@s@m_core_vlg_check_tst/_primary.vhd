library verilog;
use verilog.vl_types.all;
entity FSM_core_vlg_check_tst is
    port(
        stateout        : in     vl_logic_vector(3 downto 0);
        Z               : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end FSM_core_vlg_check_tst;
