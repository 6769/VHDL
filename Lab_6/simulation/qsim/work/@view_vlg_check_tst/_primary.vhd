library verilog;
use verilog.vl_types.all;
entity View_vlg_check_tst is
    port(
        BusWires        : in     vl_logic_vector(15 downto 0);
        Done            : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end View_vlg_check_tst;
