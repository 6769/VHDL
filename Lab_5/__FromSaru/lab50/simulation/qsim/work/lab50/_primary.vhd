library verilog;
use verilog.vl_types.all;
entity lab50 is
    port(
        reset           : in     vl_logic;
        rb              : in     vl_logic;
        clk_50m         : in     vl_logic;
        clk_28m         : in     vl_logic;
        win             : out    vl_logic;
        lose            : out    vl_logic;
        led1            : out    vl_logic_vector(7 downto 0);
        led2            : out    vl_logic_vector(7 downto 0)
    );
end lab50;
