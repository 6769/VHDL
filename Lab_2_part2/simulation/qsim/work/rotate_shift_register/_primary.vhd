library verilog;
use verilog.vl_types.all;
entity rotate_shift_register is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        hex0            : out    vl_logic_vector(7 downto 0);
        hex1            : out    vl_logic_vector(7 downto 0);
        hex2            : out    vl_logic_vector(7 downto 0);
        hex3            : out    vl_logic_vector(7 downto 0);
        hex4            : out    vl_logic_vector(7 downto 0);
        hex5            : out    vl_logic_vector(7 downto 0);
        hex6            : out    vl_logic_vector(7 downto 0);
        hex7            : out    vl_logic_vector(7 downto 0)
    );
end rotate_shift_register;
