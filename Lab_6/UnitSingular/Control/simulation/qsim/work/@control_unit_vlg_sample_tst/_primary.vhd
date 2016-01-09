library verilog;
use verilog.vl_types.all;
entity Control_unit_vlg_sample_tst is
    port(
        IRset           : in     vl_logic_vector(0 to 8);
        Resetn          : in     vl_logic;
        Run             : in     vl_logic;
        Tstep_Q         : in     vl_logic_vector(1 downto 0);
        sampler_tx      : out    vl_logic
    );
end Control_unit_vlg_sample_tst;
