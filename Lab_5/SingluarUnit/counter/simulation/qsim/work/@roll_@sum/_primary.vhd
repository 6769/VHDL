library verilog;
use verilog.vl_types.all;
entity Roll_Sum is
    port(
        Rb              : in     vl_logic;
        CLK             : in     vl_logic;
        Reset           : in     vl_logic;
        hex0            : out    vl_logic_vector(2 downto 0);
        hex1            : out    vl_logic_vector(2 downto 0);
        Sum             : out    vl_logic_vector(3 downto 0)
    );
end Roll_Sum;
