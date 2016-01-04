library verilog;
use verilog.vl_types.all;
entity lab50_vlg_check_tst is
    port(
        led1            : in     vl_logic_vector(7 downto 0);
        led2            : in     vl_logic_vector(7 downto 0);
        lose            : in     vl_logic;
        win             : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end lab50_vlg_check_tst;
