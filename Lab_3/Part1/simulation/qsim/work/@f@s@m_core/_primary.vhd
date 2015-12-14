library verilog;
use verilog.vl_types.all;
entity FSM_core is
    port(
        X               : in     vl_logic;
        CLK             : in     vl_logic;
        reset           : in     vl_logic;
        stateout        : out    vl_logic_vector(3 downto 0);
        Z               : out    vl_logic
    );
end FSM_core;
