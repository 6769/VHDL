library verilog;
use verilog.vl_types.all;
entity View_vlg_sample_tst is
    port(
        Clock           : in     vl_logic;
        DIN             : in     vl_logic_vector(15 downto 0);
        Resetn          : in     vl_logic;
        Run             : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end View_vlg_sample_tst;
