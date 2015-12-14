library verilog;
use verilog.vl_types.all;
entity View_input is
    port(
        reset           : in     vl_logic;
        w               : in     vl_logic;
        clk             : in     vl_logic;
        z               : out    vl_logic;
        state8_0        : out    vl_logic_vector(8 downto 0)
    );
end View_input;
