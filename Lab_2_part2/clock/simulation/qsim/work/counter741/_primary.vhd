library verilog;
use verilog.vl_types.all;
entity counter741 is
    port(
        clk             : in     vl_logic;
        second          : out    vl_logic;
        Qout            : out    vl_logic_vector(7 downto 0)
    );
end counter741;
