library verilog;
use verilog.vl_types.all;
entity DiceGame_controller_vlg_sample_tst is
    port(
        CLK             : in     vl_logic;
        Rb              : in     vl_logic;
        Reset           : in     vl_logic;
        Sum             : in     vl_logic_vector(3 downto 0);
        sampler_tx      : out    vl_logic
    );
end DiceGame_controller_vlg_sample_tst;
