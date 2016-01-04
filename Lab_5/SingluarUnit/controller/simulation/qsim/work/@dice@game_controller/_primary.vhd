library verilog;
use verilog.vl_types.all;
entity DiceGame_controller is
    port(
        Rb              : in     vl_logic;
        Reset           : in     vl_logic;
        CLK             : in     vl_logic;
        Sum             : in     vl_logic_vector(3 downto 0);
        Roll            : out    vl_logic;
        Win             : out    vl_logic;
        Lose            : out    vl_logic
    );
end DiceGame_controller;
