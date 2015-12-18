library verilog;
use verilog.vl_types.all;
entity View_output is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        hex0_out        : out    vl_logic_vector(7 downto 0);
        hex1_out        : out    vl_logic_vector(7 downto 0);
        hex2_out        : out    vl_logic_vector(7 downto 0)
    );
end View_output;
