library verilog;
use verilog.vl_types.all;
entity counter_max10 is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        limit           : in     vl_logic;
        carry           : out    vl_logic;
        CountedNumber   : out    vl_logic_vector(3 downto 0)
    );
end counter_max10;
