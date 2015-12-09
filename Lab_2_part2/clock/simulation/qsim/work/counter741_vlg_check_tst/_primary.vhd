library verilog;
use verilog.vl_types.all;
entity counter741_vlg_check_tst is
    port(
        Qout            : in     vl_logic_vector(7 downto 0);
        second          : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end counter741_vlg_check_tst;
